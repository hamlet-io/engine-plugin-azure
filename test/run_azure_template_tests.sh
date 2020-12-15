#!/usr/bin/env bash
set -e

echo "###############################################"
echo "# Running template tests for the AZURE provider #"
echo "###############################################"

# Source the mock utility.sh file from the testing provider
# Load any plugin provider utility.sh
IFS=';' read -ra PLUGINDIRS <<< ${GENERATION_PLUGIN_DIRS}
for dir in "${PLUGINDIRS[@]}"; do
  plugin_provider=${dir##*/}
    if [[ -e "${dir}/${plugin_provider}test/utility.sh" ]]; then
      echo "Sourcing the mock utility: ${dir}/${plugin_provider}test/utility.sh"
      . "${dir}/${plugin_provider}test/utility.sh"
    fi
done

DEFAULT_TEST_OUTPUT_DIR="$(pwd)/hamlet_tests"
TEST_OUTPUT_DIR="${TEST_OUTPUT_DIR:-${DEFAULT_TEST_OUTPUT_DIR}}"

if [[ -d "${TEST_OUTPUT_DIR}" ]]; then
    rm -r "${TEST_OUTPUT_DIR}"
    mkdir "${TEST_OUTPUT_DIR}"
else
    mkdir -p "${TEST_OUTPUT_DIR}"
fi

echo " - Output Dir: ${TEST_OUTPUT_DIR}"
echo ""
echo "--- Generating Management Contract ---"
echo ""

default_args=(
    '-i mock'
    '-p azure'
    '-p azuretest'
    '-f arm'
    "-o ${TEST_OUTPUT_DIR}"
    '-x'
)

${GENERATION_DIR}/createTemplate.sh -e unitlist ${default_args[@]}
UNIT_LIST=`jq -r '.Stages[].Steps[].Parameters | "-l \(.DeploymentGroup) -u \(.DeploymentUnit)"' < ${TEST_OUTPUT_DIR}/unitlist-managementcontract.json`
readarray -t UNIT_LIST <<< "${UNIT_LIST}"

for unit in "${UNIT_LIST[@]}";  do
 if [[ ! "${unit}" == "-l segment -u baseline" ]]; then
    unit_args=("${default_args[@]}" "${unit}")

    echo ""
    echo "--- Generating $unit ---"
    echo ""
    ${GENERATION_DIR}/createTemplate.sh -e deploymenttest ${unit_args[@]}
    ${GENERATION_DIR}/createTemplate.sh -e deployment ${unit_args[@]}

 fi
done


echo ""
echo "--- Running Tests ---"
echo ""

hamlet test generate --directory "${TEST_OUTPUT_DIR}" -o "${TEST_OUTPUT_DIR}/test_templates.py"

pushd $(pwd)
cd "${TEST_OUTPUT_DIR}"
hamlet test run -t "./test_templates.py"
popd
