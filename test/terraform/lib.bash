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

function output_only() {
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
    )
  fi
}

function log() {
  local output="$*"
  if [ -n "${output}" ]; then
  (
  echo
  if [ -n "$LOG_MARKDOWN" ]; then
    echo "<details>"
    echo "<summary>Test: ${BATS_TEST_DESCRIPTION}</summary>"
    echo
    echo '```'
  else
    echo "Test: ${BATS_TEST_DESCRIPTION}"
  fi
  echo "File: $(basename ${BATS_TEST_FILENAME})"
  echo "---------------------------------"
  echo "${output}"
  echo "---------------------------------"
  if [ -n "$LOG_MARKDOWN" ]; then
    echo '```'
    echo "</details>"
  fi
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
