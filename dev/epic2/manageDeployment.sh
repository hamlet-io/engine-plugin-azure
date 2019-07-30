#!/usr/bin/env bash

[[ -n "${GENERATION_DEBUG}" ]] && set ${GENERATION_DEBUG}
trap '. ${GENERATION_DIR}/cleanupContext.sh' EXIT SIGHUP SIGINT SIGTERM
. "${GENERATION_DIR}/common.sh"

# Defaults
DEPLOYMENT_INITIATE_DEFAULT="true"
DEPLOYMENT_MONITOR_DEFAULT="true"
DEPLOYMENT_OPERATION_DEFAULT="update"
DEPLOYMENT_WAIT_DEFAULT=30

function usage() {
  cat <<EOF

  Manage an Azure Resource Manager (ARM) deployment

  # TODO(rossmurr4y): add usage example on completion
  Usage:

  where

  (o) -d (DEPLOYMENT_OPERATION=delete)  to delete the deployment
      -h                                shows this text
  (o) -i (DEPLOYMENT_MONITOR=false)     initiates but does not monitor the deployment operation.
  (m) -l LEVEL                          is the deployment level - "account", "product", "segment", "solution", "application" or "multiple"
  (o) -m (DEPLOYMENT_INITIATE=false)    monitors but does not initiate the deployment operation.
  (o) -n DEPLOYMENT_NAME                to override the standard deployment naming.
  (o) -r REGION                         is the Azure location/region code for this deployment.
  (m) -u DEPLOYMENT_UNIT                is the deployment unit used to determine the deployment template.
  (o) -w DEPLOYMENT_WAIT                the interval between checking the progress of a stack operation.
  (o) -z DEPLOYMENT_UNIT_SUBSET         is the subset of the deployment unit required.

  (m) mandatory, (o) optional, (d) deprecated

  DEFAULTS:

  DEPLOYMENT_INITIATE  = ${DEPLOYMENT_INITIATE_DEFAULT}
  DEPLOYMENT_MONITOR   = ${DEPLOYMENT_MONITOR_DEFAULT}
  DEPLOYMENT_OPERATION = ${DEPLOYMENT_OPERATION_DEFAULT}
  DEPLOYMENT_WAIT      = ${DEPLOYMENT_WAIT_DEFAULT} seconds

EOF
}

function options() {
  # Parse options
  while getopts ":dhil:mn:r:u:w:z:" option; do
    case "${option}" in
      d) DEPLOYMENT_OPERATION=delete ;;
      h) usage; return 1 ;;
      i) DEPLOYMENT_MONITOR=false ;;
      l) LEVEL="${OPTARG}" ;;
      m) DEPLOYMENT_INITIATE=false ;;
      n) DEPLOYMENT_NAME="${OPTARG}" ;;
      r) REGION="${OPTARG}" ;;
      u) DEPLOYMENT_UNIT="${OPTARG}" ;;
      w) DEPLOYMENT_WAIT="${OPTARG}" ;;
      # TODO(rossmurr4y): Impliment az cli dry-run when available - https://github.com/Azure/azure-cli/issues/5549
      z) DEPLOYMENT_UNIT_SUBSET="${OPTARG}" ;;
      \?) fatalOption; return 1 ;;
      :) fatalOptionArgument; return 1;;
    esac
  done

  # Apply defaults if necessary
  DEPLOYMENT_OPERATION=${DEPLOYMENT_OPERATION:-${DEPLOYMENT_OPERATION_DEFAULT}}
  DEPLOYMENT_WAIT=${DEPLOYMENT_WAIT:-${DEPLOYMENT_WAIT_DEFAULT}}
  DEPLOYMENT_INITIATE=${DEPLOYMENT_INITIATE:-${DEPLOYMENT_INITIATE_DEFAULT}}
  DEPLOYMENT_MONITOR=${DEPLOYMENT_MONITOR:-${DEPLOYMENT_MONITOR_DEFAULT}}

  # Set up the context
  info "Preparing the context..."
  . "${GENERATION_DIR}/setStackContext.sh"

  return 0
}

function wait_for_deployment_execution() {

  # Assign the object path to the deployment state.
  status_attribute='.properties.provisioningState'

  info "Watching deployment execution..."

  while true; do

    case ${DEPLOYMENT_OPERATION} in
      update | create) 
        az group deployment show --resource-group ${DEPLOYMENT_NAME} --name ${DEPLOYMENT_NAME} > "${DEPLOYMENT}"
        exit_status=$?
      ;;
      delete) 
        az group deployment show --resource-group ${DEPLOYMENT_NAME} --name ${DEPLOYMENT_NAME} > "${DEPLOYMENT}" 2>/dev/null
        exit_status=$?
      ;;
      *)
        fatal "\"${DEPLOYMENT_OPERATION}\" is not one of the known stack operations."; return 1
      ;;
    esac

    [[ ("${DEPLOYMENT_OPERATION}" == "delete" ) && ("${exit_status}" -eq 255) ]] &&
      { exit_status=0; break; }

    if [[ "${DEPLOYMENT_MONITOR}" = "true" ]]; then

      ${DEPLOYMENT} | jq -r ${status_attribute} > ${DEPLOYMENT_STATE}

      case ${DEPLOYMENT_STATE} in
        Failed)
          fatal "Deployment ${DEPLOYMENT_NAME} failed, fix deployment before retrying"
          exit_status=255
          break
        ;;
        Running)
          exit_status=$?
          break
        ;;
        Succeeded)
          [[ -f "${potential_change_file}" ]] &&
          cp "${potential_change_file}" "${CHANGE}"
          break
        ;;
        *)
        ;;
      esac

    else
      break
    fi

    case ${exit_status} in
      0) ;;
      255) ;;
      *)
        return ${exit_status} ;;
    esac

  done

}

function process_deployment() {

  local stripped_template_file="${tmp_dir}/stripped_template"

  local exit_status=0

  if [[ "${DEPLOYMENT_INITIATE}" = "true" ]]; then

    case ${DEPLOYMENT_OPERATION} in
      create)

      ;;
      update)
        # Compress the template
        jq -c '.' < ${TEMPLATE} > "${stripped_template_file}"

        # Check if the resource group needs to be created
        info "Check if the ${DEPLOYMENT_NAME} resource group is already present..."
        az group exists --resource-group "${DEPLOYMENT_NAME}" > ${DEPLOYMENT_GROUP_EXISTS}

        if [[ ${DEPLOYMENT_GROUP_EXISTS} = "false" ]]; then
          az group create --resource-group "${DEPLOYMENT_NAME}" --location "${REGION}"
        fi

        
        

      ;;
      delete)
        # Delete the resource group
        info "Deleting the ${DEPLOYMENT_NAME} resource group"
        az group delete --resource-group "${DEPLOYMENT_NAME}" --no-wait --yes

        # Delete the deployment instance
        info "Deleting the ${DEPLOYMENT_NAME} deployment..."
        az group deployment delete --resource-group "${DEPLOYMENT_NAME}" --name "${DEPLOYMENT_NAME}" --no-wait

        wait_for_deployment_execution
      ;;
    esac

  fi

}

function main() {}

main "$@"