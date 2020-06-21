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
    echo "Creating templates for $unit ..."
    echo "output will be: ${TEST_OUTPUT_DIR} and unit is ${unit}"
    echo "trying segment..." && "${GENERATION_DIR}"/createTemplate.sh -i mock -p azure -p azuretest -f arm -r westus -o "${TEST_OUTPUT_DIR}" -l segment -u "${unit}" > /dev/null 2>&1 || true
    [[ ! -e "${TEST_OUTPUT_DIR}/*${unit}*-testcase.json" ]] && echo "trying solution..." && "${GENERATION_DIR}"/createTemplate.sh -i mock -p azure -p azuretest -f arm -r westus -o "${TEST_OUTPUT_DIR}" -l solution -u "${unit}" > /dev/null 2>&1 || true
    [[ ! -e "${TEST_OUTPUT_DIR}/*${unit}*-testcase.json" ]] && echo "trying application..." && "${GENERATION_DIR}"/createTemplate.sh -i mock -p azure -p azuretest -f arm -r westus -o "${TEST_OUTPUT_DIR}" -l application -u "${unit}" > /dev/null 2>&1 || true
done

hamlet test generate --directory "${TEST_OUTPUT_DIR}" -o "${TEST_OUTPUT_DIR}/test_templates.py"

cd "${TEST_OUTPUT_DIR}" || exit
echo "Running Tests..."
hamlet test run -t "./test_templates.py"