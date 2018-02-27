#!/usr/bin/env bats
# This BATS test file tests init()


load test_helper


setup() {
    eval "$(_CP)"
    source "$PIPESSH"

    w=20
    h=20

    C=(1 2 3 4 5 6 7 0) CN=8
    V=(0 1 2 3 4 5 6)   VN=7

    _RND_init
}


teardown() {
    _RND_deinit
}


@test "p=2 RNDSTART=0 KEEPCT=0" {
    eval $BATS_TEST_DESCRIPTION
    local _ci=2 _vi=3
    _RND_push $(_INVR $_ci $CN) $(_INVR $_vi $VN)

    _CP_init_pipes

    ((${#n[@]} == 2))
    ((c[0] == C[_ci]))
    ((v[0] == V[_vi]))
    ((c[1] == C[_ci + 1]))
    ((v[1] == V[_vi + 1]))
}


@test "p=1 RNDSTART=0" {
    eval $BATS_TEST_DESCRIPTION

    _CP_init_pipes

    ((${#n[@]} == 1))
    ((n[0] ==  0))
    ((l[0] ==  0))
    ((x[0] == 10))
    ((y[0] == 10))
}


@test "p=2 RNDSTART=1" {
    eval $BATS_TEST_DESCRIPTION
    _l0=2 _x0=3  _y0=7
    _l1=3 _x1=11 _y1=17
    _RND_push 0 0 \
        $_l0         $(_INVR $_x0 $w) $(_INVR $_y0 $h) \
        $((_l1 + 4)) $(_INVR $_x1 $w) $(_INVR $_y1 $h)

    _CP_init_pipes

    ((${#n[@]} == 2))
    ((l[0] == _l0))
    ((x[0] == _x0))
    ((y[0] == _y0))
    ((l[1] == _l1))
    ((x[1] == _x1))
    ((y[1] == _y1))
}
