#!/usr/bin/env bash
# Tests init()
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
    eval "$(_CP)"
    source "$PIPESSH"

    w=20
    h=20

    C=(1 2 3 4 5 6 7 0) CN=8
    V=(0 1 2 3 4 5 6)   VN=7
    E=(A B C D E F G H)

    _RND_init
}


tearDown() {
    _RND_deinit
}


test_2pipes() {
    p=2 RNDSTART=0 KEEPCT=0

    local _ci=2 _vi=3
    _RND_push $(_INVR $_ci $CN) $(_INVR $_vi $VN)

    _CP_init_pipes

    $_ASSERT_EQUALS_ 2 "${#n[@]}"
    $_ASSERT_EQUALS_ "${E[_ci]}"     "${c[0]}"
    $_ASSERT_EQUALS_ "${V[_vi]}"     "${v[0]}"
    $_ASSERT_EQUALS_ "${E[_ci + 1]}" "${c[1]}"
    $_ASSERT_EQUALS_ "${V[_vi + 1]}" "${v[1]}"
}


test_1pipe() {
    p=1 RNDSTART=0

    _CP_init_pipes

    $_ASSERT_EQUALS_  0 "${n[0]}"
    $_ASSERT_EQUALS_  0 "${l[0]}"
    $_ASSERT_EQUALS_ 10 "${x[0]}"
    $_ASSERT_EQUALS_ 10 "${y[0]}"
}


test_2pipes_random_start() {
    p=2 RNDSTART=1
    local _l0=2 _x0=3  _y0=7
    local _l1=3 _x1=11 _y1=17
    _RND_push 0 0 \
        $_l0         $(_INVR $_x0 $w) $(_INVR $_y0 $h) \
        $((_l1 + 4)) $(_INVR $_x1 $w) $(_INVR $_y1 $h)

    _CP_init_pipes

    $_ASSERT_EQUALS_ 2 "${#n[@]}"
    $_ASSERT_EQUALS_ "$_l0" "${l[0]}"
    $_ASSERT_EQUALS_ "$_x0" "${x[0]}"
    $_ASSERT_EQUALS_ "$_y0" "${y[0]}"
    $_ASSERT_EQUALS_ "$_l1" "${l[1]}"
    $_ASSERT_EQUALS_ "$_x1" "${x[1]}"
    $_ASSERT_EQUALS_ "$_y1" "${y[1]}"
}


source shunit2
