#!/usr/bin/env bash

# SECTION: Path resolution
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || exit 1
APP_DIR="${SCRIPT_DIR}/../app"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/backend.log"

# SECTION: Initialization
mkdir -p "${LOG_DIR}" || exit 1
: > "${LOG_FILE}" || exit 1
cd "${APP_DIR}" || exit 1

# SECTION: Result display
GREEN=$'\033[1;38;2;0;138;69m'
RED=$'\033[1;38;2;220;50;47m'
MUTED=$'\033[32m\033[2m'
RESET=$'\033[0m'

print_result() {
  local label="$1"
  local result="$2"
  local color="${GREEN}"

  if [[ "${result}" == FAIL* || "${result}" == "RED" ]]; then
    color="${RED}"
  fi

  printf '%-24s %s● %s%s\n' \
    "${label}" "${color}" "${result}" "${RESET}"
}

printf '=== Backend Verification ===\n'

# SECTION: Check
printf '\nCheck\n'

# STEP: gofmt
printf '\n--- gofmt -l . ---\n' >> "${LOG_FILE}" || exit 1

GOFMT_OUTPUT="$(gofmt -l . 2>&1)"
GOFMT_EXIT=$?

printf '%s\nExit code: %s\n' \
  "${GOFMT_OUTPUT}" "${GOFMT_EXIT}" >> "${LOG_FILE}" || exit 1

GOFMT_RESULT="PASS"
if [[ ${GOFMT_EXIT} -ne 0 || -n "${GOFMT_OUTPUT}" ]]; then
  GOFMT_RESULT="FAIL"
fi

printf 'Result: %s\n' "${GOFMT_RESULT}" >> "${LOG_FILE}" || exit 1

print_result "  gofmt" "${GOFMT_RESULT}"

# STEP: go vet
printf '\n--- go vet ./... ---\n' >> "${LOG_FILE}" || exit 1

GO_VET_OUTPUT="$(go vet ./... 2>&1)"
GO_VET_EXIT=$?

GO_VET_RESULT="PASS"
if [[ ${GO_VET_EXIT} -ne 0 ]]; then
  GO_VET_RESULT="FAIL"
fi

printf '%s\nExit code: %s\nResult: %s\n' \
  "${GO_VET_OUTPUT}" "${GO_VET_EXIT}" \
  "${GO_VET_RESULT}" >> "${LOG_FILE}" || exit 1

print_result "  go vet" "${GO_VET_RESULT}"

# STEP: Check result
CHECK_RESULT="GREEN"
if [[ "${GOFMT_RESULT}" == "FAIL" || "${GO_VET_RESULT}" == "FAIL" ]]; then
  CHECK_RESULT="RED"
fi

print_result "Check Result" "${CHECK_RESULT}"

# SECTION: Test
printf '\nTest\n'

# STEP: go test
printf '\n--- go test -json ./... ---\n' >> "${LOG_FILE}" || exit 1

GO_TEST_OUTPUT="$(go test -json ./... 2>&1)"
GO_TEST_EXIT=$?

printf '%s\nExit code: %s\n' \
  "${GO_TEST_OUTPUT}" "${GO_TEST_EXIT}" >> "${LOG_FILE}" || exit 1

GO_TEST_RESULT="PASS"
if [[ ${GO_TEST_EXIT} -ne 0 ]]; then
  GO_TEST_RESULT="FAIL"
fi

# STEP: Count test results
read -r TEST_PASSED TEST_TOTAL < <(
  printf '%s\n' "${GO_TEST_OUTPUT}" | awk '
    /"Test":/ && /"Action":"pass"/ { passed++; total++ }
    /"Test":/ && /"Action":"fail"/ { total++ }
    END { print passed+0, total+0 }
  '
)

printf 'Result: %s(%s/%s)\n' \
  "${GO_TEST_RESULT}" "${TEST_PASSED}" "${TEST_TOTAL}" >> "${LOG_FILE}" || exit 1

print_result "  go test" "${GO_TEST_RESULT}(${TEST_PASSED}/${TEST_TOTAL})"

# STEP: Test result
TEST_RESULT="GREEN"
if [[ "${GO_TEST_RESULT}" == "FAIL" ]]; then
  TEST_RESULT="RED"
fi

print_result "Test Result" "${TEST_RESULT}"

# SECTION: Overall result
RESULT="ALL GREEN"
EXIT_CODE=0

if [[ "${CHECK_RESULT}" == "RED" || "${TEST_RESULT}" == "RED" ]]; then
  RESULT="RED"
  EXIT_CODE=1
fi

printf '\nCheck: %s\nTest: %s\nResult: %s\nExit code: %s\n' \
  "${CHECK_RESULT}" "${TEST_RESULT}" \
  "${RESULT}" "${EXIT_CODE}" >> "${LOG_FILE}" || exit 1

printf '\n'
print_result "Result" "${RESULT}"
printf '%sLog: %s%s\n' "${MUTED}" "${LOG_FILE}" "${RESET}"

exit "${EXIT_CODE}"
