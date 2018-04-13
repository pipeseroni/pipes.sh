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

    $_ASSERT_EQUALS_ 0 "'${V[*]}'"
    $_ASSERT_EQUALS_ 1 "$VN"
    $_ASSERT_EQUALS_ "'1 2 3 4 5 6 7 0'" "'${C[*]}'"
    $_ASSERT_EQUALS_ 8 "$CN"
}


test_p_0_invalid() {
    parse -p 0

    $_ASSERT_EQUALS_ 1 "$p"
}


test_p_2() {
    parse -p 2

    $_ASSERT_EQUALS_ 2 "$p"
}


test_t_3() {
    parse -t 3

    $_ASSERT_EQUALS_ 3 "'${V[@]}'"
    $_ASSERT_EQUALS_ 1 "$VN"
}


test_t_3_1_4() {
    parse -t 3 -t 1 -t 4

    $_ASSERT_EQUALS_ "'3 1 4'" "'${V[*]}'"
    $_ASSERT_EQUALS_ 3 "$VN"
}


test_t_999_outofrange() {
    parse -t 999

    $_ASSERT_EQUALS_ 0 "'${V[*]}'"
    $_ASSERT_EQUALS_ 1 "$VN"
}


test_t_custom() {
    local _t=fedcba9876543210
    parse -t "c$_t"

    $_ASSERT_EQUALS_ "$_t" "${sets[V[VN-1]]}"
}


test_c_3() {
    parse -c 3

    $_ASSERT_EQUALS_ 3 "'${C[*]}'"
    $_ASSERT_EQUALS_ 1 "$CN"
}


test_c_3_1_4() {
    parse -c 3 -c 1 -c 4

    $_ASSERT_EQUALS_ "'3 1 4'" "'${C[*]}'"
    $_ASSERT_EQUALS_ 3 "$CN"
}


test_c_8_outofrange() {
    parse -c 8

    $_ASSERT_EQUALS_ "'1 2 3 4 5 6 7 0'" "'${C[*]}'"
    $_ASSERT_EQUALS_ 8 "$CN"
}


test_f_50() {
    parse -f 50

    $_ASSERT_EQUALS_ 50 "$f"
}


test_f_10_invalid() {
    parse -f 10

    $_ASSERT_EQUALS_ 75 "$f"
}


test_s_10() {
    parse -s 10

    $_ASSERT_EQUALS_ 10 "$s"
}


test_s_30_invalid() {
    parse -s 30

    $_ASSERT_EQUALS_ 13 "$s"
}


test_r_0() {
    parse -r 0

    $_ASSERT_EQUALS_ 0 "$r"
}


test_r__1_invalid() {
    parse -r -1

    $_ASSERT_EQUALS_ 2000  "$r"
}


test_RBCK() {
    parse -R -B -C -K

    $_ASSERT_EQUALS_ 1 "$RNDSTART"
    $_ASSERT_EQUALS_ 0 "$BOLD"
    $_ASSERT_EQUALS_ 1 "$NOCOLOR"
    $_ASSERT_EQUALS_ 1 "$KEEPCT"
}


source shunit2
