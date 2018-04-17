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

    COLORS=8
}


# test valid option arguments using
#   $1: option name
#   $2-: option arguments to be parsed one by one
# parse() must return 0 and the variable value must be same as the used $2-
_test_opt_args() {
    local _opt=$1
    shift
    while (($#)); do
        unset $_opt
        parse -$_opt "$1"
        $_ASSERT_EQUALS_ "'-$_opt $1'" 0 $?
        $_ASSERT_EQUALS_ "'-$_opt $1'" "'$1'" "'${!_opt}'"
        shift
    done
}


# test invalid option arguments using
#   $1: option name
#   $2-: invalid option arguments to be parsed one by one
# parse() must return 1
_test_opt_args_invalid() {
    local _opt=$1
    shift
    while (($#)); do
        parse -$_opt "$1" 2>/dev/null
        $_ASSERT_EQUALS_ "'-$_opt $1'" 1 $?
        shift
    done
}


# this fails when default settings are changed, which should be not changed
# without a discussion.
test_default_settings() {
    parse

    $_ASSERT_EQUALS_    1 "$p"
    $_ASSERT_EQUALS_   75 "$f"
    $_ASSERT_EQUALS_   13 "$s"
    $_ASSERT_EQUALS_ 2000 "$r"
    $_ASSERT_EQUALS_    0 "$t"

    $_ASSERT_EQUALS_ 0 "$RNDSTART"
    $_ASSERT_EQUALS_ 1 "$BOLD"
    $_ASSERT_EQUALS_ 0 "$NOCOLOR"
    $_ASSERT_EQUALS_ 0 "$KEEPCT"

    $_ASSERT_EQUALS_ "''" "'${V[*]}'"
    $_ASSERT_EQUALS_ "''" "'${C[*]}'"
}


test_p() {
    _test_opt_args p 1 2 666
    _test_opt_args_invalid p 0 NaN
}


test_t() {
    unset V
    parse -t 3
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ 3 "'${V[*]}'"

    unset V
    parse -t 3 -t 1 -t 4
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ "'3 1 4'" "'${V[*]}'"

    unset V
    local _t=fedcba9876543210
    parse -t "c$_t"
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ "$_t" "${sets[V[0]]}"

    parse -t $((${#sets[@]} - 1))
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ "$_t" "${sets[V[1]]}"
}


test_t_invalid() {
    _test_opt_args_invalid t ${#sets[@]} 999 NaN cfoobar
}


test_c() {
    unset C
    parse -c 3
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ 3 "'${C[*]}'"

    unset C
    parse -c 3 -c 1 -c 4
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ "'3 1 4'" "'${C[*]}'"
}


test_c_hex() {
    COLORS=256
    unset C
    parse -c#f -c#1f -c '#AF'
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ "'15 31 175'" "'${C[*]}'"

    COLORS=16777216
    unset C
    parse -c#C001AF
    $_ASSERT_EQUALS_ 0 $?
    $_ASSERT_EQUALS_ 12583343 "'${C[*]}'"
}


test_c_invalid() {
    _test_opt_args_invalid c 8 NaN '#z' '#10'
}


test_f() {
    _test_opt_args f 20 50 100
    _test_opt_args_invalid f 0 19 101 NaN
}


test_s() {
    _test_opt_args s 5 10 15
    _test_opt_args_invalid f 0 4 16 NaN
}


test_r() {
    _test_opt_args r 0 10 10000
    _test_opt_args_invalid r NaN
}


test_RBCK() {
    parse -R -B -C -K

    $_ASSERT_EQUALS_ 1 "$RNDSTART"
    $_ASSERT_EQUALS_ 0 "$BOLD"
    $_ASSERT_EQUALS_ 1 "$NOCOLOR"
    $_ASSERT_EQUALS_ 1 "$KEEPCT"
}


test_opt_invalid() {
    parse -'!@#$%^&*()' 2>/dev/null
    $_ASSERT_EQUALS_ 1 $?
}


test_args() {
    parse foo 2>/dev/null
    $_ASSERT_EQUALS_ 1 $?

    parse foo bar 2>/dev/null
    $_ASSERT_EQUALS_ 1 $?
}


source shunit2
