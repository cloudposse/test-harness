#!/usr/bin/env bash

shopt -s nullglob

OUTPUT_LOG=output.txt

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
  (
  local output="$*"
  if [ -n "${output}" ]; then
  echo
  echo "Test: ${BATS_TEST_DESCRIPTION}"
  echo "File: $(basename ${BATS_TEST_FILENAME})"
  echo "---------------------------------"
  echo "${output}"
  echo "---------------------------------"
  echo
  fi
  ) | tee -a ${OUTPUT_LOG} >&3
}

function clean() {
  rm -rf .terraform
}

function skip_unless_terraform() {
  [[ -n $(echo *.tf) ]] || skip "no *.tf files"
}
