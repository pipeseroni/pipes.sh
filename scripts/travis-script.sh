#!/usr/bin/env bash
# Script for Travis CI script phase
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


set -o errexit


print_command() {
    printf "\n\n$FGRN\$$SGR0 $BOLD$BASH_COMMAND$SGR0\n"
}


benchmark() {
    local revs=$(git describe --always --tags HEAD~{2..0})
    "$SCRIPTS_DIR/benchmark.sh" $revs
}


init() {
    SCRIPTS_DIR=${BASH_SOURCE%/*}

    SGR0=$(tput sgr0)
    BOLD=$(tput bold)
    FGRN=$(tput setf 2)
    FCYN=$(tput setf 3)
    FWHT=$(tput setf 7)

    TIMEFORMAT="$FCYN#$SGR0 Elapased $BOLD$FCYN%R$SGR0 seconds"
}


main() {
    trap 'print_command' DEBUG

    # simple invocations check
    ./pipes.sh -v
    ./pipes.sh -h

    # unittest and benchmark
    time make test
    time benchmark

    # system-wide install check
    sudo make install
    pipes.sh -v
    sudo make uninstall

    # manpage HTML check
    make pipes.sh.6.html
}


init
main "$@"
