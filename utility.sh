#!/usr/bin/env bash

# Utility Functions for the Azure provider
#
# This script is designed to be sourced into other scripts

# -- Keys --
function az_create_pki_credentials() {
  local dir="$1"; shift
  local region="$1"; shift
  local account="$1"; shift
  local keytype="$1"; shift

  if [[ ! -f "${dir}/.azure-${account}-${region}-${keytype}-crt.pem" ]]; then
      openssl genrsa -out "${dir}/.azure-${account}-${region}-${keytype}-prv.pem.plaintext" 2048 || return $?
      openssl rsa -in "${dir}/.azure-${account}-${region}-${keytype}-prv.pem.plaintext" -pubout > "${dir}/.azure-${account}-${region}-${keytype}-crt.pem" || return $?
  fi

  if [[ ! -f "${dir}/.gitignore" ]]; then
    cat << EOF > "${dir}/.gitignore"
*.plaintext
*.decrypted
*.ppk
EOF
  fi

  return 0
}

function az_show_key_credentials() {
  local vaultName="$1"; shift
  local keyName="$1"; shift

  local keyId="https://${vaultName}.azure.net/keys/${keyName}"

  az keyvault key show --id "${keyId}"
}

# -- Secrets --
function az_add_secret() {
  local vaultName="$1"; shift
  local keyName="$1"; shift
  local secret="$1"; shift

  info "Adding secret ${secret} to vault ${vaultName} ..."
  if [[ -f ${secret} ]]; then
    az keyvault secret set --vault-name "${vaultName}" --name "${keyName}" --file "${secret}" 2>&1 > /dev/null
  else
    az keyvault secret set --vault-name "${vaultName}" --name "${keyName}" --value "${secret}" 2>&1 > /dev/null
  fi
}

function az_check_secret() {
  local vaultName="$1"; shift
  local secretName="$1"; shift

  local secretId="https://${vaultName}.vault.azure.net/secrets/${secretName}"

  az keyvault secret show --id "${secretId}" > /dev/null
}

function az_delete_secret() {
  local vaultName="$1"; shift
  local keyName="$1"; shift

  local keyId="https://${vaultName}.vault.azure.net/keys/${keyName}"

  #azure returns a large object upon successful deletion, so we redirect that.
  az keyvault key show --id "${keyId}" 2>&1 > /dev/null && \
  { az keyvault secret delete --id "${keyId}" > /dev/null || return $?; }

  return 0
}