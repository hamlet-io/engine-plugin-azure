#!/usr/bin/env bash

# Utility Functions for the Azure provider
#
# This script is designed to be sourced into other scripts

function az_create_pki_credentials() {
  local dir="$1"; shift
  local region="$1"; shift
  local account="$1"; shift

  if [[ (! -f "${dir}/azure-ssh-crt.pem") &&
        (! -f "${dir}/azure-ssh-prv.pem") &&
        (! -f "${dir}/.azure-ssh-crt.pem") &&
        (! -f "${dir}/.azure-ssh-prv.pem") &&
        (! -f "${dir}/.azure-${account}-${region}-ssh-crt.pem") &&
        (! -f "${dir}/.azure-${account}-${region}-ssh-prv.pem") ]]; then
      openssl genrsa -out "${dir}/.azure-${account}-${region}-ssh-prv.pem.plaintext" 2048 || return $?
      openssl rsa -in "${dir}/.azure-${account}-${region}-ssh-prv.pem.plaintext" -pubout > "${dir}/.azure-${account}-${region}-ssh-crt.pem" || return $?
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

function az_delete_pki_credentials() {
  local dir="$1"; shift
  local region="$1"; shift
  local account="$1"; shift

  local restore_nullglob="$(shopt -p nullglob)"
  shopt -s nullglob

  rm -f "${dir}"/.azure-${account}-${region}-ssh-crt* "${dir}"/.azure-${account}-${region}-ssh-prv*

  ${restore_nullglob}
}

# -- SSH --

function az_check_ssh_credentials() {
  local region="$1"; shift
  local keyId="$1"; shift

  az keyvault key show --id "${keyId}" 2>&1 > /dev/null
}

function az_show_ssh_credentials() {
  local region="$1"; shift
  local keyId="$1"; shift

  az keyvault key show --id "${keyId}"
}

function az_update_ssh_credentials() {
  local region="$1"; shift
  local vault="$1"; shift
  local name="$1"; shift
  local crt_file="$1"; shift

  local crt_content=$(dos2unix < "${crt_file}" | awk 'BEGIN {RS="\n"} /^[^-]/ {printf $1}')
  ${crt_content} > ${crt_file}

  az keyvault key import --pem-file "${crt_file}" --vault-name "${vault}" --name "${name}"
}

function az_delete_ssh_credentials() {
  local region="$1"; shift
  local keyId="$1"; shift

  #azure returns a large object upon successful deletion, so we redirect that.
  az keyvault key show --id "${keyId}" 2>&1 > /dev/null && \
  { az keyvault key delete --id "${keyId}" > /dev/null || return $?; }

  return 0
}