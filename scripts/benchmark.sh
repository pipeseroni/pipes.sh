#!/usr/bin/env bash
# Benchmark pipes.sh by revisions excluding terminal render time
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
# Usage: see scripts/README.


PIPESSH='pipes.sh'
LIMIT=${LIMIT:-1000}
TIMEF=${TIMEF:-time_ndis}

SED_E=(
    -E                           # ERE (alias to -r in GNU sed)
    -e 's/read|sleep|cat/:/g'    # NOP
    -e 's/! :/:/'                # ! read -> ! : -> :
    -e 's/tput cols/echo 80/'    # 80x24
    -e 's/tput lines/echo 24/'
)
SED_CLNUP=("${SED_E[@]}" -e 's/&& t=0/\&\& cleanup/')
SED_BREAK=("${SED_E[@]}" -e 's/&& t=0/\&\& break/')


# monkey-patch gitrevision $1 pipes.sh:
# 1. make read/sleep/cat nop
# 2. exit when reach -r LIMIT
# 3. have a (logical) terminal size 80x24
#
# Some early commits use sleep to work around Bash < 4 for delay < 1 second,
# and cat is used to clear out standard input, which could hang if not made
# nop.
mkp_pipes() {
    local GIT
    # . refers to pipes.sh in working directory
    if [[ $1 == . ]]; then
        # may not always be run in reposistory root, could be under scripts/
        GIT=(cat "$(dirname "${BASH_SOURCE[0]}")/../$PIPESSH")
    else
        GIT=(git cat-file --textconv "$1:$PIPESSH")
    fi
    if "${GIT[@]}" | grep cleanup &>/dev/null; then
        "${GIT[@]}" | sed "${SED_CLNUP[@]}"
    else
        "${GIT[@]}" | sed "${SED_BREAK[@]}"
    fi
}


# time the monkey-patched gitrevision $1 pipes.sh with Bash time keyword.
time_pipes() {
    local TIMEFORMAT=%R
    time bash <(mkp_pipes "$1") -r $LIMIT
}


# timing helper function that sends pipes to /dev/null, and Bash keyword time
# output redirects to stdout.
time_ndis() {
    {
        time_pipes "$1" >/dev/null
    } 2>&1
}


# timing helper function that swaps stdout and stderr, so that pipes are on
# stderr and Bash keyword time output are on stdout.
time_disp() {
    time_pipes "$1" 3>&1 1>&2 2>&3
}


# benchmark a gitrevision ($1) pipes.sh without terminal render time
# (>/dev/null), the result is pipe chars per second.
benchmark() {
    local t=$($TIMEF "$1")
    local cps="$(bc <<< "$LIMIT/$t")"
    printf '%-10s: %6d c/s\n' "${1:-staged}" "$cps"
}


main() {
    while (($#)); do
        benchmark "$1"
        shift
    done
}


main "$@"
