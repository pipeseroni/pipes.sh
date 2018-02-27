#!/usr/bin/env bats
# This BATS test file tests parse()


load test_helper


setup() {
    source "$PIPESSH"
}


# this fails when default settings are changed, which should be not changed
# without a discussion.
@test "parse  # default settings" {
    $BATS_TEST_DESCRIPTION

    ((p ==    1))
    ((f ==   75))
    ((s ==   13))
    ((r == 2000))
    ((t ==    0))

    ((RNDSTART == 0))
    ((BOLD     == 1))
    ((NOCOLOR  == 0))
    ((KEEPCT   == 0))

    [[ "${V[@]}" == '0' ]]
    ((VN == 1))
    [[ "${C[@]}" == '1 2 3 4 5 6 7 0' ]]
    ((CN == 8))
}


@test "parse -p 0  # invalid" {
    $BATS_TEST_DESCRIPTION

    ((p == 1))
}


@test "parse -p 2" {
    $BATS_TEST_DESCRIPTION

    ((p == 2))
}


@test "parse -t 3" {
    $BATS_TEST_DESCRIPTION

    [[ "${V[@]}" == '3' ]]
    ((VN == 1))
}


@test "parse -t 3 -t 1 -t 4" {
    $BATS_TEST_DESCRIPTION

    [[ "${V[@]}" == '3 1 4' ]]
    ((VN == 3))
}


@test "parse -t 999  # out of range" {
    $BATS_TEST_DESCRIPTION

    [[ "${V[@]}" == '0' ]]
    ((VN == 1))
}


@test "parse -t cfedcba9876543210" {
    $BATS_TEST_DESCRIPTION

    [[ "${sets[V[VN - 1]]}" == fedcba9876543210 ]]
}


@test "parse -c 3" {
    $BATS_TEST_DESCRIPTION

    [[ "${C[@]}" == '3' ]]
    ((CN == 1))
}


@test "parse -c 3 -c 1 -c 4" {
    $BATS_TEST_DESCRIPTION

    [[ "${C[@]}" == '3 1 4' ]]
    ((CN == 3))
}


@test "parse -c 8  # out of range" {
    $BATS_TEST_DESCRIPTION

    [[ "${C[@]}" == '1 2 3 4 5 6 7 0' ]]
    ((CN == 8))
}


@test "parse -f 50" {
    $BATS_TEST_DESCRIPTION

    ((f == 50))
}


@test "parse -f 10  # invalid" {
    $BATS_TEST_DESCRIPTION

    ((f == 75))
}


@test "parse -s 10" {
    $BATS_TEST_DESCRIPTION

    ((s == 10))
}


@test "parse -s 30  # invalid" {
    $BATS_TEST_DESCRIPTION

    ((s == 13))
}


@test "parse -r 0" {
    $BATS_TEST_DESCRIPTION

    ((r == 0))
}


@test "parse -r -1  # invalid" {
    $BATS_TEST_DESCRIPTION

    ((r == 2000))
}


@test "parse -R -B -C -K" {
    $BATS_TEST_DESCRIPTION

    ((RNDSTART == 1))
    ((BOLD     == 0))
    ((NOCOLOR  == 1))
    ((KEEPCT   == 1))
}
