#!/usr/bin/env bash

# Mocking Utility Functions for the Azure provider

function az_copy_from_blob(){
  local storageAccountName="$1"; shift
  local containerName="$1"; shift
  local blobName="$1"; shift
  local fileName="$1"; shift
  local resourceGroup="$1"; shift

  echo "mocking the copying of a blob to local machine"
  touch "${tmpdir}/${fileName}.zip"
}
