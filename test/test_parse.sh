#!/usr/bin/env bash
# Tests parse()
# Copyright (c) 2018 Pipeseroni/pipes.sh contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


source "$(dirname "${BASH_SOURCE[0]}")"/helper.sh


setUp() {
    source "$PIPESSH"
}


test_COLORS() {
    TERM=$TEST_TERM parse
    $_ASSERT_EQUALS_ 8 $COLORS
    TERM=xterm-16color parse
    $_ASSERT_EQUALS_ 16 $COLORS
    TERM=xterm-256color parse
    $_ASSERT_EQUALS_ 256 $COLORS
    # skipping when xterm-direct not in terminfo, likely because ncurses is not
    # >= 6.1.  FIXME: remove this when 6.1 is commonly available.
    if ! tput -T xterm-direct sgr0 &>/dev/null; then
        printf '%s%s is not available, test skipped%s\n' \
               "$(tput setf 5)" xterm-direct "$(tput sgr0)" >&2
        return
    fi
    TERM=xterm-direct parse
    $_ASSERT_EQUALS_ 16777216 $COLORS
}


test_SGRs() {
    TERM=$TEST_TERM parse

    local _exp _ret
    CATV_EXP_RET     $'\e(B\e[m' "$SGR0"
    $_ASSERT_EQUALS_ "'$_exp'"   "'$_ret'"

    CATV_EXP_RET     $'\e[1m'    "$SGR_BOLD"
    $_ASSERT_EQUALS_ "'$_exp'"   "'$_ret'"
}


# this fails when default settings are changed, which should be not changed
# without a discussion.
test_default_settings() {
    TERM=$TEST_TERM parse

    $_ASSERT_EQUALS_    1 "$p"
    $_ASSERT_EQUALS_   75 "$f"
    $_ASSERT_EQUALS_   13 "$s"
    $_ASSERT_EQUALS_ 2000 "$r"
    $_ASSERT_EQUALS_    0 "$t"

    $_ASSERT_EQUALS_ 0 "$RNDSTART"
    $_ASSERT_EQUALS_ 1 "$BOLD"
    $_ASSERT_EQUALS_ 0 "$NOCOLOR"
    $_ASSERT_EQUALS_ 0 "$KEEPCT"

    $_ASSERT_EQUALS_ 0 "'${V[*]}'"
    $_ASSERT_EQUALS_ 1 "$VN"
    $_ASSERT_EQUALS_ "'1 2 3 4 5 6 7 0'" "'${C[*]}'"
    $_ASSERT_EQUALS_ 8 "$CN"
}


test_p_0_invalid() {
    TERM=$TEST_TERM parse -p 0

    $_ASSERT_EQUALS_ 1 "$p"
}


test_p_2() {
    TERM=$TEST_TERM parse -p 2

    $_ASSERT_EQUALS_ 2 "$p"
}


test_t_3() {
    TERM=$TEST_TERM parse -t 3

    $_ASSERT_EQUALS_ 3 "'${V[@]}'"
    $_ASSERT_EQUALS_ 1 "$VN"
}


test_t_3_1_4() {
    TERM=$TEST_TERM parse -t 3 -t 1 -t 4

    $_ASSERT_EQUALS_ "'3 1 4'" "'${V[*]}'"
    $_ASSERT_EQUALS_ 3 "$VN"
}


test_t_999_outofrange() {
    TERM=$TEST_TERM parse -t 999

    $_ASSERT_EQUALS_ 0 "'${V[*]}'"
    $_ASSERT_EQUALS_ 1 "$VN"
}


test_t_custom() {
    local _t=fedcba9876543210
    TERM=$TEST_TERM parse -t "c$_t"

    $_ASSERT_EQUALS_ "$_t" "${sets[V[VN-1]]}"
}


test_c_3() {
    TERM=$TEST_TERM parse -c 3

    $_ASSERT_EQUALS_ 3 "'${C[*]}'"
    $_ASSERT_EQUALS_ 1 "$CN"
}


test_c_hex() {
    TERM=xterm-256color parse -c#f -c#1f -c '#AF'
    $_ASSERT_EQUALS_ "'15 31 175'" "'${C[*]}'"

    # skipping when xterm-direct not in terminfo, likely because ncurses is not
    # >= 6.1.  FIXME: remove this when 6.1 is commonly available.
    if ! tput -T xterm-direct sgr0 &>/dev/null; then
        printf '%s%s is not available, test skipped%s\n' \
               "$(tput setf 5)" xterm-direct "$(tput sgr0)" >&2
        return
    fi
    C=()
    TERM=xterm-direct parse -c#C001AF
    $_ASSERT_EQUALS_ 12583343 "'${C[*]}'"
}


test_c_3_1_4() {
    TERM=$TEST_TERM parse -c 3 -c 1 -c 4

    $_ASSERT_EQUALS_ "'3 1 4'" "'${C[*]}'"
    $_ASSERT_EQUALS_ 3 "$CN"
}


test_c_8_outofrange() {
    TERM=$TEST_TERM parse -c 8

    $_ASSERT_EQUALS_ "'1 2 3 4 5 6 7 0'" "'${C[*]}'"
    $_ASSERT_EQUALS_ 8 "$CN"
}


test_f_50() {
    TERM=$TEST_TERM parse -f 50

    $_ASSERT_EQUALS_ 50 "$f"
}


test_f_10_invalid() {
    TERM=$TEST_TERM parse -f 10

    $_ASSERT_EQUALS_ 75 "$f"
}


test_s_10() {
    TERM=$TEST_TERM parse -s 10

    $_ASSERT_EQUALS_ 10 "$s"
}


test_s_30_invalid() {
    TERM=$TEST_TERM parse -s 30

    $_ASSERT_EQUALS_ 13 "$s"
}


test_r_0() {
    TERM=$TEST_TERM parse -r 0

    $_ASSERT_EQUALS_ 0 "$r"
}


test_r__1_invalid() {
    TERM=$TEST_TERM parse -r -1

    $_ASSERT_EQUALS_ 2000  "$r"
}


test_RBCK() {
    TERM=$TEST_TERM parse -R -B -C -K

    $_ASSERT_EQUALS_ 1 "$RNDSTART"
    $_ASSERT_EQUALS_ 0 "$BOLD"
    $_ASSERT_EQUALS_ 1 "$NOCOLOR"
    $_ASSERT_EQUALS_ 1 "$KEEPCT"
}


test_E() {
    local _tests_fields=5
    local _tests=(
    #   TERM            BOLD    C  E
    #                      NOCOLOR
        $TEST_TERM      0  0    3  $'\e(B\e[m\e[33m'
        xterm-16color   0  0    3  $'\e(B\e[m\e[33m'
        xterm-256color  0  0    3  $'\e(B\e[m\e[33m'
        xterm-direct    0  0    3  $'\e(B\e[m\e[33m'
        xterm-256color  0  0   73  $'\e(B\e[m\e[38;5;73m'
        xterm-direct    0  0   73  $'\e(B\e[m\e[38:2::0:0:73m'
        xterm-direct    0  0  273  $'\e(B\e[m\e[38:2::0:1:17m'

        $TEST_TERM      1  0    3  $'\e(B\e[m\e[1m\e[33m'
        xterm-16color   1  0    3  $'\e(B\e[m\e[1m\e[33m'
        xterm-256color  1  0    3  $'\e(B\e[m\e[1m\e[33m'
        xterm-direct    1  0    3  $'\e(B\e[m\e[1m\e[33m'
        xterm-256color  1  0   73  $'\e(B\e[m\e[1m\e[38;5;73m'
        xterm-direct    1  0   73  $'\e(B\e[m\e[1m\e[38:2::0:0:73m'
        xterm-direct    1  0  273  $'\e(B\e[m\e[1m\e[38:2::0:1:17m'

        $TEST_TERM      0  1    3  $'\e(B\e[m'
        xterm-16color   0  1    3  $'\e(B\e[m'
        xterm-256color  0  1    3  $'\e(B\e[m'
        xterm-direct    0  1    3  $'\e(B\e[m'
        xterm-256color  0  1   73  $'\e(B\e[m'
        xterm-direct    0  1   73  $'\e(B\e[m'
        xterm-direct    0  1  273  $'\e(B\e[m'

        $TEST_TERM      1  1    3  $'\e(B\e[m\e[1m'
        xterm-16color   1  1    3  $'\e(B\e[m\e[1m'
        xterm-256color  1  1    3  $'\e(B\e[m\e[1m'
        xterm-direct    1  1    3  $'\e(B\e[m\e[1m'
        xterm-256color  1  1   73  $'\e(B\e[m\e[1m'
        xterm-direct    1  1   73  $'\e(B\e[m\e[1m'
        xterm-direct    1  1  273  $'\e(B\e[m\e[1m'
    )
    local _i _exp _ret
    for ((_i = 0; _i < ${#_tests[@]}; _i += _tests_fields)); do
        local _TERM=${_tests[_i]}
        # skipping when xterm-direct not in terminfo, likely because ncurses is
        # not >= 6.1.  FIXME: remove this when 6.1 is commonly available.
        if [[ $_TERM == xterm-direct ]]; then
            if ! tput -T "$_TERM" sgr0 &>/dev/null; then
                printf '%s%s is not available, test skipped%s\n' \
                       "$(tput setf 5)" "$_TERM" "$(tput sgr0)" >&2
                continue
            fi
        fi
        BOLD=${_tests[_i + 1]}
        NOCOLOR=${_tests[_i + 2]}
        C=(4 ${_tests[_i + 3]})  # put into C[1]
        TERM=$_TERM parse
        CATV_EXP_RET "${_tests[_i + 4]}" "${E[1]}"
        $_ASSERT_EQUALS_ "'TERM=$TERM BOLD=$BOLD NOCOLOR=$NOCOLOR C=$C'" \
                         "'$_exp'" "'$_ret'"
    done
}


source shunit2
