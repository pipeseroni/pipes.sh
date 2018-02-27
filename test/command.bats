#!/usr/bin/env bats
# This BATS test file tests pipes.sh command


load test_helper


@test "$PIPESSH -h" {
    run $BATS_TEST_DESCRIPTION

    ((status == 0))
    # if there is something, it might be working
    ((${#lines[0]} && ${#lines[@]}))
}


@test "$PIPESSH -v" {
    run $BATS_TEST_DESCRIPTION

    ((status == 0))
    local VER="$(sed -n '/^VERSION=/ s/VERSION=//p' "$PIPESSH")"
    [[ "${lines[0]}" == "pipes.sh $VER" ]]
}
