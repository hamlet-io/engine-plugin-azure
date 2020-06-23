#!/usr/bin/env bash

echo "###############################################"
echo "# Running template tests for the AZURE provider #"
echo "###############################################"

DEFAULT_TEST_OUTPUT_DIR="$(pwd)/hamlet_tests"
TEST_OUTPUT_DIR="${TEST_OUTPUT_DIR:-${DEFAULT_TEST_OUTPUT_DIR}}"

if [[ -d "${TEST_OUTPUT_DIR}" ]]; then
    rm -r "${TEST_OUTPUT_DIR}"
    mkdir "${TEST_OUTPUT_DIR}"
else
    mkdir -p "${TEST_OUTPUT_DIR}"
fi

echo "Output Dir: ${TEST_OUTPUT_DIR}"
echo "Generating unit list..."
"${GENERATION_DIR}"/createTemplate.sh -i mock -p azure -p azuretest -f arm -r westus -o "${TEST_OUTPUT_DIR}" -l unitlist
UNIT_LIST="$(jq -r '.DeploymentUnits | join(" ")' < "${TEST_OUTPUT_DIR}/unitlistconfig.json")"

for unit in $UNIT_LIST; do

    args=(
        '-i mock'
        '-p azure'
        '-p azuretest'
        '-f arm'
        '-r westus'
        "-o ${TEST_OUTPUT_DIR}"
    )

    case "${unit}" in
        segment-*)
            args=("${args[@]}" '-l segment')
            ;;
        solution-*)
            args=("${args[@]}" '-l solution')
            ;;
        application-*)
            args=("${args[@]}" '-l application')
            ;;
        *)
            return
            ;;
    esac

    args=("${args[@]}" "-u ${unit}")

    echo "Generating Tests: $unit ..."
    ${GENERATION_DIR}/createTemplate.sh ${args[@]} > /dev/null 2>&1 || true
done

hamlet test generate --directory "${TEST_OUTPUT_DIR}" -o "${TEST_OUTPUT_DIR}/test_templates.py"

pushd $(pwd) || return
cd "${TEST_OUTPUT_DIR}" || return
echo "Running Tests..."
hamlet test run -t "./test_templates.py"
popd || return