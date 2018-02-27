#!/usr/bin/env bats
# This BATS test file tests main()


load test_helper


setup() {
    eval "$(_CP)"
    source "$PIPESSH"

    w=20  h=20
    i=0
    l[i]=0  n[i]=0
      C=(1 2 3)      V=(4 5 6)
     CN=${#C[@]}    VN=${#C[@]}
    c[i]=${C[0]}  v[i]=${V[0]}

    sets[V[i]]='0123456789ABCDEF'

    BOLD=1
    NOCOLOR=0
    KEEPCT=0

    _RND_init
}


teardown() {
    _RND_deinit
}


@test "pipe goes up" {
    x[i]=10 y[i]=10 l[i]=0

    _CP_newpos

    ((x[i] == 10))
    ((y[i] ==  9))
}


@test "pipe goes right" {
    x[i]=10 y[i]=10 l[i]=1

    _CP_newpos

    ((x[i] == 11))
    ((y[i] == 10))
}


@test "pipe goes down" {
    x[i]=10 y[i]=10 l[i]=2

    _CP_newpos

    ((x[i] == 10))
    ((y[i] == 11))
}


@test "pipe goes left" {
    x[i]=10 y[i]=10 l[i]=3

    _CP_newpos

    ((x[i] ==  9))
    ((y[i] == 10))
}


@test "pipe crosses top edge, KEEPCT=0" {
    x[i]=10 y[i]=0 l[i]=0
    local _ci=2 _vi=1
    _RND_push $(_INVR $_ci $CN) $(_INVR $_vi $VN)

    _CP_newpos
    _CP_warp

    ((x[i] == 10))
    ((y[i] == 19))
    ((c[i] == C[_ci]))
    ((v[i] == V[_vi]))
}


@test "pipe crosses right edge, KEEPCT=0" {
    x[i]=19 y[i]=10 l[i]=1
    local _ci=2 _vi=1
    _RND_push $(_INVR $_ci $CN) $(_INVR $_vi $VN)

    _CP_newpos
    _CP_warp

    ((x[i] ==  0))
    ((y[i] == 10))
    ((c[i] == C[_ci]))
    ((v[i] == V[_vi]))
}


@test "pipe crosses bottom edge, KEEPCT=0" {
    x[i]=10 y[i]=19 l[i]=2
    local _ci=2 _vi=1
    _RND_push $(_INVR $_ci $CN) $(_INVR $_vi $VN)

    _CP_newpos
    _CP_warp

    ((x[i] == 10))
    ((y[i] ==  0))
    ((c[i] == C[_ci]))
    ((v[i] == V[_vi]))
}


@test "pipe crosses left edge, KEEPCT=0" {
    x[i]=0 y[i]=10 l[i]=3
    local _ci=2 _vi=1
    _RND_push $(_INVR $_ci $CN) $(_INVR $_vi $VN)

    _CP_newpos
    _CP_warp

    ((x[i] == 19))
    ((y[i] == 10))
    ((c[i] == C[_ci]))
    ((v[i] == V[_vi]))
}


@test "pipe crosses top edge, KEEPCT=1" {
    x[i]=10 y[i]=0 l[i]=0
    KEEPCT=1
    local _c=${c[i]} _v=${v[i]}

    _CP_newpos
    _CP_warp

    ((x[i] == 10))
    ((y[i] == 19))
    ((c[i] == _c))
    ((v[i] == _v))
}


@test "pipe crosses right edge, KEEPCT=1" {
    x[i]=19 y[i]=10 l[i]=1
    KEEPCT=1
    local _c=${c[i]} _v=${v[i]}

    _CP_newpos
    _CP_warp

    ((x[i] ==  0))
    ((y[i] == 10))
    ((c[i] == _c))
    ((v[i] == _v))
}


@test "pipe crosses bottom edge, KEEPCT=1" {
    x[i]=10 y[i]=19 l[i]=2
    KEEPCT=1
    local _c=${c[i]} _v=${v[i]}

    _CP_newpos
    _CP_warp

    ((x[i] == 10))
    ((y[i] ==  0))
    ((c[i] == _c))
    ((v[i] == _v))
}


@test "pipe crosses left edge, KEEPCT=1" {
    x[i]=0 y[i]=10 l[i]=3
    KEEPCT=1
    local _c=${c[i]} _v=${v[i]}

    _CP_newpos
    _CP_warp

    ((x[i] == 19))
    ((y[i] == 10))
    ((c[i] == _c))
    ((v[i] == _v))
}


@test "newdir" {
    skip
}


@test "BOLD" {
    BOLD=0
    [[ "$(_CP_print)" == $'\e[0m\e[31m0' ]]
    BOLD=1
    [[ "$(_CP_print)" == $'\e[1m\e[31m0' ]]
}


@test "NOCOLOR" {
    BOLD=0
    NOCOLOR=0
    [[ "$(_CP_print)" == $'\e[0m\e[31m0' ]]
    NOCOLOR=1
    [[ "$(_CP_print)" == $'\e[0m\e[0m0' ]]
}


@test "l[] n[] -> sets[l * 4 + n]" {
    local _li _ni _I

    BOLD=0
    NOCOLOR=1
    for ((_li = 0; _li < 4; _li++)); do
       l[i]=_li
        for ((_ni = 0; _ni < 4; _ni++)); do
            n[i]=_ni
            printf -v _I '%X' $((_li * 4 + _ni))
            echo "l=$_li  n=$_ni  I=$_I"
            [[ "$(_CP_print)" == $'\e[0m\e[0m'$_I ]]
        done
    done
}
