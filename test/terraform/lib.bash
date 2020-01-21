#!/usr/bin/env bash

shopt -s nullglob

BATS_LOG="${BATS_LOG:-test.log}"

function skip_if_disabled() {
  local env
  env=${BATS_TEST_FILENAME}
  env=$(basename $env .bats)
  env=$(basename $BATS_TEST_DIRNAME)_$env
  env=${env^^}
  env=${env//-/_}
  env=${env//./_}
  env=TEST_${env}
  if [ "${!env}" == "false" ]; then
    skip "${env} is false"
  fi
}

function log() {
  local output="$*"
  if [ -n "${output}" ]; then
  (
  echo
  echo "Test: ${BATS_TEST_DESCRIPTION}"
  echo "File: $(basename ${BATS_TEST_FILENAME})"
  echo "---------------------------------"
  echo "${output}"
  echo "---------------------------------"
  echo
  ) | tee -a ${BATS_LOG} >&3
  fi
}

function clean() {
  rm -rf .terraform
}

function skip_unless_terraform() {
  [[ -n $(echo *.tf) ]] || skip "no *.tf files"
}

function terraform_docs() {
  which awk 2>&1 >/dev/null || ( echo "awk not available"; exit 1)
  which terraform 2>&1 >/dev/null || ( echo "terraform not available"; exit 1)
  which terraform-docs 2>&1 >/dev/null || ( echo "terraform-docs not available"; exit 1)
  terraform-docs --no-providers --no-header $1 $2
}
