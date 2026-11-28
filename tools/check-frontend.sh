#!/usr/bin/env bash

# SECTION: Path resolution
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || exit 1
APP_DIR="${SCRIPT_DIR}/../app/frontend"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/frontend.log"

# SECTION: Initialization
mkdir -p "${LOG_DIR}" || exit 1
: > "${LOG_FILE}" || exit 1
cd "${APP_DIR}" || exit 1

TEST_JSON="$(mktemp "${LOG_DIR}/vitest.XXXXXX")" || exit 1
trap 'rm -f -- "${TEST_JSON}"' EXIT

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

# SECTION: Check execution
run_check() {
  local label="$1"
  local script="$2"
  local output
  local exit_code
  local result="PASS"

  printf '\n--- npm run %s ---\n' \
    "${script}" >> "${LOG_FILE}" || exit 1

  output="$(npm run "${script}" 2>&1)"
  exit_code=$?

  if [[ ${exit_code} -ne 0 ]]; then
    result="FAIL"
    CHECK_RESULT="RED"
  fi

  printf '%s\nExit code: %s\nResult: %s\n' \
    "${output}" "${exit_code}" \
    "${result}" >> "${LOG_FILE}" || exit 1

  print_result "  ${label}" "${result}"
}

printf '=== Frontend Verification ===\n'

# SECTION: Check
printf '\nCheck\n'

CHECK_RESULT="GREEN"

# STEP: Prettier
run_check "Prettier" "check:prettier"

# STEP: svelte-check
run_check "svelte-check" "check:svelte"

# STEP: tsc
run_check "tsc" "check:tsc"

# STEP: ESLint
run_check "ESLint" "check:eslint"

# STEP: Check result
print_result "Check Result" "${CHECK_RESULT}"

# SECTION: Test
printf '\nTest\n'

# STEP: Vitest
printf '\n--- npm test ---\n' >> "${LOG_FILE}" || exit 1

VITEST_OUTPUT="$(npm test -- \
  --reporter=default \
  --reporter=json \
  --outputFile.json="${TEST_JSON}" 2>&1)"
VITEST_EXIT=$?

printf '%s\nExit code: %s\n' \
  "${VITEST_OUTPUT}" "${VITEST_EXIT}" >> "${LOG_FILE}" || exit 1

VITEST_RESULT="PASS"
if [[ ${VITEST_EXIT} -ne 0 ]]; then
  VITEST_RESULT="FAIL"
fi

# STEP: Count test results
if [[ ${VITEST_EXIT} -eq 0 && ! -s "${TEST_JSON}" ]]; then
  # NOTE: Vitest may not generate a JSON report when no tests exist.
  TEST_PASSED=0
  TEST_TOTAL=0
else
  TEST_COUNTS="$(node --input-type=module - "${TEST_JSON}" 2>> "${LOG_FILE}" <<'NODE'
import { readFileSync } from "node:fs";

const report = JSON.parse(readFileSync(process.argv[2], "utf8"));
const passed = report.numPassedTests;
const failed = report.numFailedTests;

if (!Number.isInteger(passed) || !Number.isInteger(failed)) {
  throw new Error("Invalid Vitest test counts");
}

console.log(`${passed} ${passed + failed}`);
NODE
)"
  COUNT_EXIT=$?

  if [[ ${COUNT_EXIT} -eq 0 ]]; then
    read -r TEST_PASSED TEST_TOTAL <<< "${TEST_COUNTS}"
  else
    TEST_PASSED="?"
    TEST_TOTAL="?"
    VITEST_RESULT="FAIL"

    printf 'Failed to read Vitest test counts.\n' \
      >> "${LOG_FILE}" || exit 1
  fi
fi

printf 'Result: %s(%s/%s)\n' \
  "${VITEST_RESULT}" "${TEST_PASSED}" "${TEST_TOTAL}" \
  >> "${LOG_FILE}" || exit 1

print_result "  Vitest" "${VITEST_RESULT}(${TEST_PASSED}/${TEST_TOTAL})"

# STEP: Test result
TEST_RESULT="GREEN"
if [[ "${VITEST_RESULT}" == "FAIL" ]]; then
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
