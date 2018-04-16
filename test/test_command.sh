#!/usr/bin/env bash
# Test command-line options
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


test_command_help() {
    TERM=$TEST_TERM run "$PIPESSH" -h

    $_ASSERT_EQUALS_ 0 "$status"
    # if there is something, it might be working
    $_ASSERT_NOT_NULL_ "'${lines[*]}'"
}


test_command_version() {
    TERM=$TEST_TERM run "$PIPESSH" -v

    $_ASSERT_EQUALS_ 0 "$status"
    local VER="$(sed -n '/^VERSION=/ s/VERSION=//p' "$PIPESSH")"
    $_ASSERT_EQUALS_ "'pipes.sh $VER'" "'${lines[0]}'"
}


test_command_TERM() {
    TERM='NOSUCHTERMWHATSOEVER' run "$PIPESSH" -v 2>/dev/null

    $_ASSERT_EQUALS_ 3 "$status"
}


source shunit2
