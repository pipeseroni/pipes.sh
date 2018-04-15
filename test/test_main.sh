#!/usr/bin/env bash
# Tests main()
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

    w=20  h=20
    i=0
    l[i]=0  n[i]=0
    x[i]=0  y[i]=0

      C=(1 2 3)      V=(4 5 6)
     CN=${#C[@]}    VN=${#C[@]}
    c[i]=${C[0]}  v[i]=${V[0]}

    sets[V[i]]='0123456789ABCDEF'

    BOLD=1
    NOCOLOR=0
    KEEPCT=0

    _RND_init
}


tearDown() {
    _RND_deinit
}


_test_newpos() {
    local testname=$1
    x[i]=$2
    y[i]=$3
    l[i]=$4

    _CP_newpos

    $_ASSERT_EQUALS_ "'$testname'" "$5" "${x[i]}"
    $_ASSERT_EQUALS_ "'$testname'" "$6" "${y[i]}"
}


test_newpos() {
    local _test_fields=6
    local _tests=(
        # dir       x   y   l   nx  ny
        'up'        10  10  0   10   9
        'right'     10  10  1   11  10
        'down'      10  10  2   10  11
        'left'      10  10  3    9  10
    )
    local _i
    for ((_i = 0; _i < ${#_tests[@]}; _i += _test_fields)); do
        setUp
        _test_newpos "${_tests[@]:_i:_i + _test_fields}"
        tearDown
    done
}


_test_cross() {
    x[i]=$2
    y[i]=$3
    l[i]=$4
    KEEPCT=$7
    local testname="$1 KEEPCT=$KEEPCT"
    [[ ${10} ]] &&_RND_push ${10}

    _CP_newpos
    _CP_warp

    $_ASSERT_EQUALS_ "'$testname'" "$5" "${x[i]}"
    $_ASSERT_EQUALS_ "'$testname'" "$6" "${y[i]}"
    $_ASSERT_EQUALS_ "'$testname'" "$8" "${c[i]}"
    $_ASSERT_EQUALS_ "'$testname'" "$9" "${v[i]}"
}


test_cross() {
    local _ci=2  _vi=1
    local _RND="$(_INVR $_ci $CN) $(_INVR $_vi $VN)"
    local _test_fields=10
    local _tests=(
        # edge    x   y   l  nx  ny  KEEPCT  c            v            RND
        'top'     10   0  0  10  19  0       "${C[_ci]}"  "${V[_vi]}"  "$_RND"
        'right'   19  10  1   0  10  0       "${C[_ci]}"  "${V[_vi]}"  "$_RND"
        'bottom'  10  19  2  10   0  0       "${C[_ci]}"  "${V[_vi]}"  "$_RND"
        'left'     0  10  3  19  10  0       "${C[_ci]}"  "${V[_vi]}"  "$_RND"
        'top'     10   0  0  10  19  1       "${c[i]}"    "${v[i]}"    ''
        'right'   19  10  1   0  10  1       "${c[i]}"    "${v[i]}"    ''
        'bottom'  10  19  2  10   0  1       "${c[i]}"    "${v[i]}"    ''
        'left'     0  10  3  19  10  1       "${c[i]}"    "${v[i]}"    ''
    )
    local _i
    for ((_i = 0; _i < ${#_tests[@]}; _i += _test_fields)); do
        setUp
        _test_cross "${_tests[@]:_i:_i + _test_fields}"
        tearDown
    done
}


test_newdir_no_turns() {
    local _l

    s=1
    for ((_l = 0; _l < 4; _l++)); do
        l[i]=$_l
         _RND_push $M -1
        _CP_newdir

        $_ASSERT_EQUALS_ "_l=$_l" "${l[i]}" "${n[i]}"
    done
}


test_newdir_turning() {
    local _l _n

    s=2
    for ((_l = 0; _l < 4; _l++)); do
        for ((_d = 0; _d < 2; _d++)); do
            l[i]=$_l
            _RND_push 0 $_d

            _CP_newdir

            ((_n = (_l + (2 * _d) - 1 + 4) % 4))
            $_ASSERT_EQUALS_ "'_l=$_l _d=$_d l[i]=${l[i]}'" "$_n" "${n[i]}"
        done
    done
}


test_cur_pos() {
    local exp ret
    x[i]=3  y[i]=5
    exp='^[['$((y[i] + 1))';'$((x[i] + 1))'H^[['$BOLD'm^[[31m0'
    ret=$(_CP_print | cat -v)
    $_ASSERT_EQUALS_ "'$exp'" "'$ret'"
}


test_BOLD() {
    local exp ret
    BOLD=0
    exp='^[['$((y[i] + 1))';'$((x[i] + 1))'H^[['$BOLD'm^[[31m0'
    ret=$(_CP_print | cat -v)
    $_ASSERT_EQUALS_ "'$exp'" "'$ret'"
    BOLD=1
    exp='^[['$((y[i] + 1))';'$((x[i] + 1))'H^[['$BOLD'm^[[31m0'
    ret=$(_CP_print | cat -v)
    $_ASSERT_EQUALS_ "'$exp'" "'$ret'"
}


test_NOCOLOR() {
    local exp ret
    NOCOLOR=0
    exp='^[['$((y[i] + 1))';'$((x[i] + 1))'H^[['$BOLD'm^[[31m0'
    ret=$(_CP_print | cat -v)
    $_ASSERT_EQUALS_ "'$exp'" "'$ret'"
    NOCOLOR=1
    exp='^[['$((y[i] + 1))';'$((x[i] + 1))'H^[['$BOLD'm^[[0m0'
    ret=$(_CP_print | cat -v)
    $_ASSERT_EQUALS_ "'$exp'" "'$ret'"
}


test_sets_ln() {
    local _li _ni _I ret

    for ((_li = 0; _li < 4; _li++)); do
       l[i]=_li
        for ((_ni = 0; _ni < 4; _ni++)); do
            n[i]=_ni
            printf -v _I '%X' $((_li * 4 + _ni))
            ret=$(_CP_print)
            ret=${ret:${#ret} - 1}
            $_ASSERT_EQUALS_ "'l=$_li  n=$_ni  I=$_I'" "$_I" "$ret"
        done
    done
}


source shunit2
