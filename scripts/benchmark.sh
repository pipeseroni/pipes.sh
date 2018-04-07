#!/usr/bin/env bash
# Benchmark pipes.sh by revisions
# Copyright (c) 2018 Pipeseroni/pipes.sh contributors
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
#
# Usage: scripts/benchmark.sh <revision>...
#
# Example:
#
#     $ scripts/benchmark.sh f7d0941 $(git tag) HEAD
#     f7d0941   :    564 c/s
#     2013-02-01:    534 c/s
#     2013-02-06:    534 c/s
#     [snip]
#     v1.2.0    :    529 c/s
#     v1.3.0    :    492 c/s
#     HEAD      :   3030 c/s


PIPESSH='pipes.sh'
LIMIT=1000

SED_E=(
    -e 's/read\|sleep\|cat/:/g'  # NOP
    -e 's/! :/:/'                # ! read -> ! : -> :
)
SED_CLNUP=("${SED_E[@]}" -e 's/&& t=0/\&\& cleanup/')
SED_BREAK=("${SED_E[@]}" -e 's/&& t=0/\&\& break/')


# monkey-patch gitrevision $1 pipes.sh:
# 1. make read/sleep/cat nop
# 2. exit when reach -r LIMIT
#
# Some early commits use sleep to work around Bash < 4 for delay < 1 second,
# and cat is used to clear out standard input, which could hang if not made
# nop.
mkp_pipes() {
    local GIT=(git cat-file --textconv "$1:$PIPESSH")
    if "${GIT[@]}" | grep cleanup &>/dev/null; then
        "${GIT[@]}" | sed "${SED_CLNUP[@]}"
    else
        "${GIT[@]}" | sed "${SED_BREAK[@]}"
    fi
}


# time the monkey-patched gitrevision $1 pipes.sh with Bash builtiin time.
# The stdout and stderr are swapped.  So the pipes are on stderr and time's
# result (real %e) is on stdout.
run() {
    TIME=%e time bash <(mkp_pipes "$1") -r $LIMIT 3>&2 2>&1 1>&3
}


# benchmark a gitrevision ($1) pipes.sh, the result is pipe chars per second.
benchmark() {
    local t=$(run "$1" 2>/dev/null)
    local cps="$(bc <<< "$LIMIT/$t")"
    printf '%-10s: %6d c/s\n' "$1" "$cps"
}


main() {
    while (($#)); do
        benchmark "$1"
        shift
    done
}


main "$@"
