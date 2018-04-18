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

    C=(1 2 3)
    E=(X Y Z)
    c=(X Y Z)
    CN=${#C[@]}

    V=(4 5 6)
    v=(4 5 6)
    VN=${#C[@]}

    sets[V[i]]='0123456789ABCDEF'
    _CP_init_SETS

    BOLD=1
    NOCOLOR=0
    KEEPCT=0

    _RND_init
}


tearDown() {
    _RND_deinit
}


test_init_termcap_vars_COLORS() {
    TERM=$TEST_TERM _CP_init_termcap_vars
    $_ASSERT_EQUALS_ 8 $COLORS
    TERM=xterm-16color _CP_init_termcap_vars
    $_ASSERT_EQUALS_ 16 $COLORS
    TERM=xterm-256color _CP_init_termcap_vars
    $_ASSERT_EQUALS_ 256 $COLORS
    # skipping when xterm-direct not in terminfo, likely because ncurses is not
    # >= 6.1.  FIXME: remove this when 6.1 is commonly available.
    if ! tput -T xterm-direct sgr0 &>/dev/null; then
        printf '%s%s is not available, test skipped%s\n' \
               "$(tput setf 5)" xterm-direct "$(tput sgr0)" >&2
        return
    fi
    TERM=xterm-direct _CP_init_termcap_vars
    $_ASSERT_EQUALS_ 16777216 $COLORS
}


test_init_termcap_vars_SGR() {
    TERM=$TEST_TERM _CP_init_termcap_vars

    local _exp _ret
    CATV_EXP_RET     $'\e(B\e[m' "$SGR0"
    $_ASSERT_EQUALS_ "'$_exp'"   "'$_ret'"

    CATV_EXP_RET     $'\e[1m'    "$SGR_BOLD"
    $_ASSERT_EQUALS_ "'$_exp'"   "'$_ret'"
}


test_init_VC() {
    local _V _C _VN _CN

    _VN=1  _V=0
    _CN=8  _C='1 2 3 4 5 6 7 0'
    unset V VN C CN
    _CP_init_VC

    $_ASSERT_EQUALS_ "'$_V'"  "'${V[*]}'"
    $_ASSERT_EQUALS_ "'$_C'"  "'${C[*]}'"
    $_ASSERT_EQUALS_ "'$_VN'" "'$VN'"
    $_ASSERT_EQUALS_ "'$_CN'" "'$CN'"

    _VN=2  _V='1 2'
    _CN=3  _C='4 5 6'
    unset V VN C CN
    V=($_V)
    C=($_C)
    _CP_init_VC

    $_ASSERT_EQUALS_ "'$_V'"  "'${V[*]}'"
    $_ASSERT_EQUALS_ "'$_C'"  "'${C[*]}'"
    $_ASSERT_EQUALS_ "'$_VN'" "'$VN'"
    $_ASSERT_EQUALS_ "'$_CN'" "'$CN'"
}


test_init_E() {
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
        TERM=$_TERM _CP_init_termcap_vars
        TERM=$_TERM _CP_init_E
        CATV_EXP_RET "${_tests[_i + 4]}" "${E[1]}"
        $_ASSERT_EQUALS_ "'TERM=$TERM BOLD=$BOLD NOCOLOR=$NOCOLOR C=$C'" \
                         "'$_exp'" "'$_ret'"
    done
}


test_init_SETS() {
    local _exp

    unset SETS
    sets=('1234567890abcdef')
    _CP_init_SETS
    _exp='1 2 3 4 5 6 7 8 9 0 a b c d e f'
    $_ASSERT_EQUALS_ "'$_exp'" "'${SETS[*]}'"

    unset SETS
    sets=('1234567890abcdef' 'foobarABCDEFGHIJ')
    _CP_init_SETS
     _exp='1 2 3 4 5 6 7 8 9 0 a b c d e f '
    _exp+='f o o b a r A B C D E F G H I J'
    $_ASSERT_EQUALS_ "'$_exp'" "'${SETS[*]}'"
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
        'top'     10   0  0  10  19  0       "${c[_ci]}"  "${V[_vi]}"  "$_RND"
        'right'   19  10  1   0  10  0       "${c[_ci]}"  "${V[_vi]}"  "$_RND"
        'bottom'  10  19  2  10   0  0       "${c[_ci]}"  "${V[_vi]}"  "$_RND"
        'left'     0  10  3  19  10  0       "${c[_ci]}"  "${V[_vi]}"  "$_RND"
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
    x[i]=3  y[i]=5
    local _exp _ret
    CATV_EXP_RET $'\e['$((y[i] + 1))';'$((x[i] + 1))'HX0' "$(_CP_print)"
    $_ASSERT_EQUALS_ "'$_exp'" "'$_ret'"
}


test_sets_ln() {
    local _li _ni _I _ret

    for ((_li = 0; _li < 4; _li++)); do
       l[i]=_li
        for ((_ni = 0; _ni < 4; _ni++)); do
            n[i]=_ni
            printf -v _I '%X' $((_li * 4 + _ni))
            _ret=$(_CP_print)
            _ret=${_ret: -1}  # oh dear Bash, you love space, don't you?
            $_ASSERT_EQUALS_ "'l=$_li  n=$_ni  I=$_I'" "$_I" "$_ret"
        done
    done
}


source shunit2
