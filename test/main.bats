#!/usr/bin/env bats
# This BATS test file tests main()


load test_helper


setup() {
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


@test "newdir: no turns" {
    local _l

    s=1
    for ((_l = 0; _l < 4; _l++)); do
        l[i]=$_l
         _RND_push $M -1
        _CP_newdir

        echo _l=$_l: n[i]=${n[i]} l[i]=${l[i]}
        ((n[i] == l[i]))
    done
}


@test "newdir: turning" {
    local _l _n

    s=2
    for ((_l = 0; _l < 4; _l++)); do
        for ((_d = 0; _d < 2; _d++)); do
            l[i]=$_l
            _RND_push 0 $_d

            _CP_newdir

            ((_n = (_l + (2 * _d) - 1 + 4) % 4, 1))
            echo _l=$_l _d:$_d: n[i]=${n[i]} _n=$_n l[i]=${l[i]}
            ((n[i] == _n))
        done
    done
}


@test "CSI Cursor Position" {
    x[i]=3  y[i]=5
    [[ "$(_CP_print)" == $'\e[5;3H'* ]]
}


@test "BOLD" {
    BOLD=0
    [[ "$(_CP_print)" == *$'\e[0m'* ]]
    BOLD=1
    [[ "$(_CP_print)" == *$'\e[1m'* ]]
}


@test "NOCOLOR" {
    NOCOLOR=0
    [[ "$(_CP_print)" == *$'\e[31m'? ]]
    NOCOLOR=1
    [[ "$(_CP_print)" == *$'\e[0m'? ]]
}


@test "l[] n[] -> sets[l * 4 + n]" {
    local _li _ni _I

    for ((_li = 0; _li < 4; _li++)); do
       l[i]=_li
        for ((_ni = 0; _ni < 4; _ni++)); do
            n[i]=_ni
            printf -v _I '%X' $((_li * 4 + _ni))
            echo "l=$_li  n=$_ni  I=$_I"
            [[ "$(_CP_print)" == *$_I ]]
        done
    done
}
