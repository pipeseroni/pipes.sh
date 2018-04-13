#!/usr/bin/env bash
# Copyright (c) 2018 Pipeseroni/pipes.sh contributors
# Copyright (c) 2018 Yu-Jie Lin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


main() {
    source "$(dirname "${BASH_SOURCE[0]}")"/helper.sh

    local BLD="$(tput bold)"
    local RED="${BLD}$(tput setaf 1)"
    local GRN="${BLD}$(tput setaf 2)"
    local YLW="${BLD}$(tput setaf 3)"
    local CYN="${BLD}$(tput setaf 6)"
    local RST="$(tput sgr0)"

    local test_script test_scripts script_failures
    for test_script in "$TEST_DIR"/test_*.sh; do
        name="$(basename "$test_script")"
        echo    '########################################'
        echo -e "# ${YLW}$name${RST}"
        echo    '##'
        (exec "$test_script";) || ((script_failures++))
        ((test_scripts++))
        echo
        echo    '##'
        echo -e "# ${YLW}$name${RST}"
        echo    '########################################'
        echo
    done

    echo
    echo -e "Ran ${CYN}${test_scripts}${RST} test scripts."
    echo
    if ((script_failures)); then
        echo -e "${RED}FAILED${RST}" \
                "(${RED}script failures=${script_failures}${RST})"
    else
        echo -e "${GRN}OK${RST}"
    fi

    return $script_failures
}


main "$@"
