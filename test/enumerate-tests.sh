#!/usr/bin/env bash
# Enumerate all tests runnable on the current system
set -eu
cd "$(dirname "$0")"/..

list_executable_bats() {
     find -L "$@" -name '*.bats' -perm -0111 -maxdepth 1 || true
} 2>/dev/null

{
list_executable_bats test {shell,util,compiler,runner,inference,ddlib}/test
for testDir in test/*/env.sh; do
    testDir=${testDir%/env.sh}
    testShouldWork="$testDir"/should-work.sh
    ! [[ -x "$testShouldWork" ]] || "$testShouldWork" || continue
    list_executable_bats "$testDir"
    list_executable_bats "$testDir"/scalatests
done
} | sort
