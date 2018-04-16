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


TEST_DIR="$(dirname "${BASH_SOURCE[0]}")"
PIPESSH="$TEST_DIR/../pipes.sh"
TEST_TERM=xterm


# cherrypick a piece of code to test and replace RANDOM with a mock, see _RND
# below.
#
# Wrap code with two comments like
#
#     # +_CP_foobar
#     : some code here
#     ((1 + RANDOM * 3))
#     : more code here
#     # -_CP_foobar
#
# It will be extracted and echo out as
#
#     _CP_foobar() {
#     : some code here
#     ((1 + $((_RND_SEQ[_RND_IDX++])) * 3))
#     : more code here
#     }
#
# The result can be used by eval to define the functions.
#
# FIXME check if the names in two comments actually match, we should find +_CP,
# then extract with -_CP, this ensures valid pair, and it can even extract
# nested pairs.
_CP() {
    < "$PIPESSH" \
    sed -n -E \
        -e '/^ *# \+_CP_[a-zA-Z0-9_]+$/,/^ *# -_CP_[a-zA-Z0-9_]+$/ {' \
            -e 's/^ *# \+(_CP_[a-zA-Z0-9_]+)$/\1()\{/' \
            -e 's/^ *# -_CP_[a-zA-Z0-9_]+$/\}/' \
            -e 'p' \
        -e '}' |
    sed -E -e 's/\$?RANDOM/$((_RND_SEQ[_RND_IDX\+\+]))/g'
}


# _RND_* are the mock RANDOM functions, used in conjunction with the _CP above.
# They should be used in the following method
#
#     _RND_init            # => _RND_IDX = 0 and _RND_SEQ=()
#     _RND_push 3 1 4 1 5  # => _RND_SEQ=(3 1 4 1 5)
#
# When the tested code expands RANDOM, which is in turn the following code
# after being replaced by _CP():
#
#     $((_RND_SEQ[_RND_IDX++]))
#
# With each expansion, one number will be expanded, then next as the index
# _RND_IDX being incremented.
#
# Note that: there is no range check, when the index goes beyond the range,
# the replaced code would be expanded to nothing, which should trigger a syntax
# error, for example:
#
#     ((number + RANDOM * 3))
#  => ((number +        * 3))  # a syntax error
#
# Limitation: this mock is very basic, you can not use it when RANDOM is used
# in the process of the tested code and in subprocess that it spawns, as
# anything being updated in the subprocess will not be updated to the parent,
# that means the _RND_IDX.
#
# Limitation: since the mock RANDOM is an expansion, it could be expanded even
# it might not be executed, for example:
#
#    n = RANDOM
#    n = n % 2 ? 7 : RANDOM
#
# Even when first RANDOM % 2 == 1, the mock RANDOM will still be expanded, the
# next number is expanded and _RND_SEQ is increased.
#
# You will need to add dummy value for second RANDOM, or rewrite the second
# evaluation to be:
#
#    ((n % 2)) && ((n = 7)) || ((n = RANDOM))


# initializes a mock RANDOM
_RND_init() {
    _RND_IDX=0
    declare -ga _RND_SEQ=()
}


_RND_deinit() {
    unset _RND_IDX _RND_SEQ
}


# push numbers into the sequence
_RND_push() {
    _RND_SEQ+=("$@")
}


# _INVR $X $N
# Calculates an inverted number for a RANDOM in X = N * RANDOM / M,
# the calculated value can be _RND_push and the X will be the result when
# tested code expands RANDOM.
#
# Note that: it actually calculates RANDOM for (X + (X + 1)) / 2, the mid-point
# between X and X + 1, it would be truncated/floored to be X, otherwise the
# resulted X might be slightly short for X and ending up as X - 1
#
# For example, X = 2, but it might be 1.999999... as the integer operations
# goes, therefore calculating for 2.5 is a safe way to ensure X = X.
_INVR() {
    echo $((M * (2 * $1 + 1) / (2 * $2)))
}


# Bats-like run function
run() {
    unset status lines
    local _lines
    _lines=$("$@")
    status=$?
    # load the output of command into lines without trailing newlines
    mapfile -t lines < <(printf "$_lines")
}


# `cat -v` on $1 and $2 into $_exp and $_ret
CATV_EXP_RET() {
    _exp=$(printf "$1" | cat -v)
    _ret=$(printf "$2" | cat -v)
}
