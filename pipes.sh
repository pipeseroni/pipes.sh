#!/usr/bin/env bash
# pipes.sh: Animated pipes terminal screensaver.
# https://github.com/pipeseroni/pipes.sh
#
# Copyright (c) 2015-2018 Pipeseroni/pipes.sh contributors
# Copyright (c) 2013-2015 Yu-Jie Lin
# Copyright (c) 2010 Matthew Simpson
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


VERSION=1.3.0

M=32768  # Bash RANDOM maximum + 1
p=1      # number of pipes
f=75     # frame rate
s=13     # probability of straight fitting
r=2000   # characters limit
t=0      # iteration counter for -r character limit
w=80     # terminal size
h=24

# ab -> sets[][idx] = a*4 + b
# 0: up, 1: right, 2: down, 3: left
# 00 means going up   , then going up   -> ┃
# 12 means going right, then going down -> ┓
sets=(
    "┃┏ ┓┛━┓  ┗┃┛┗ ┏━"
    "│╭ ╮╯─╮  ╰│╯╰ ╭─"
    "│┌ ┐┘─┐  └│┘└ ┌─"
    "║╔ ╗╝═╗  ╚║╝╚ ╔═"
    "|+ ++-+  +|++ +-"
    "|/ \/-\  \|/\ /-"
    ".. ....  .... .."
    ".o oo.o  o.oo o."
    "-\ /\|/  /-\/ \|"  # railway
    "╿┍ ┑┚╼┒  ┕╽┙┖ ┎╾"  # knobby pipe
)
SETS=()  # rearranged all pipe chars into individul elements for easier access

# pipes'
x=()  # current position
y=()
l=()  # current directions
      # 0: up, 1: right, 2: down, 3: left
n=()  # new directions
v=()  # current types
c=()  # current escape codes

# selected pipes'
V=()  # types (indexes to sets[])
C=()  # color indices for tput setaf
VN=0  # number of selected types
CN=0  # number of selected colors
E=()  # pre-generated escape codes from BOLD, NOCOLOR, and C

# switches
RNDSTART=0  # randomize starting position and direction
BOLD=1
NOCOLOR=0
KEEPCT=0    # keep pipe color and type


# print help message in 72-char width
print_help() {
    local cgap
    printf -v cgap '%*s' $((15 - ${#COLORS})) ''
    cat <<HELP
Usage: $(basename $0) [OPTION]...
Animated pipes terminal screensaver.

  -p [1-]               number of pipes (D=1)
  -t [0-$((${#sets[@]} - 1))]              pipe type (D=0)
  -t c[16 chars]        custom pipe type
  -c [0-$COLORS]${cgap}pipe color INDEX (TERM=$TERM), can be
                        hexadecimal with '#' prefix
                        (D=-c 1 -c 2 ... -c 7 -c 0)
  -f [20-100]           framerate (D=75)
  -s [5-15]             going straight probability, 1 in (D=13)
  -r [0-]               reset after (D=2000) characters, 0 if no reset
  -R                    randomize starting position and direction
  -B                    no bold effect
  -C                    no color
  -K                    keep pipe color and type when crossing edges
  -h                    print this help message
  -v                    print version number

Note: -t and -c can be used more than once.
HELP
}


# parse command-line options
# It depends on a valid COLORS which is set by _CP_init_termcap_vars
parse() {
    # test if $1 is a natural number in decimal, an integer >= 0
    is_N() {
        [[ -n $1 && -z ${1//[0-9]} ]]
    }


    # test if $1 is a hexadecimal string
    is_hex() {
        [[ -n $1 && -z ${1//[0-9A-Fa-f]} ]]
    }


    # print error message for invalid argument to standard error, this
    # - mimics getopts error message
    # - use all positional parameters as error message
    # - has a newline appended
    # $arg and $OPTARG are the option name and argument set by getopts.
    pearg() {
        printf "%s: -$arg invalid argument -- $OPTARG; %s\n" "$0" "$*" >&2
    }


    OPTIND=1
    while getopts "p:t:c:f:s:r:RBCKhv" arg; do
    case $arg in
        p)
            if is_N "$OPTARG" && ((OPTARG > 0)); then
                p=$OPTARG
            else
                pearg 'must be an integer and greater than 0'
                return 1
            fi
            ;;
        t)
            if [[ "$OPTARG" = c???????????????? ]]; then
                V+=(${#sets[@]})
                sets+=("${OPTARG:1}")
            elif is_N "$OPTARG" && ((OPTARG < ${#sets[@]})); then
                V+=($OPTARG)
            else
                pearg 'must be an integer and from 0 to' \
                      "$((${#sets[@]} - 1)); or a custom type"
                return 1
            fi
            ;;
        c)
            if [[ $OPTARG == '#'* ]]; then
                if ! is_hex "${OPTARG:1}"; then
                    pearg 'unrecognized hexadecimal string'
                    return 1
                fi
                if ((16$OPTARG >= COLORS)); then
                    pearg 'hexadecimal must be from #0 to' \
                          "#$(printf '%X' $((COLORS - 1)))"
                    return 1
                fi
                C+=($((16$OPTARG)))
            elif is_N "$OPTARG" && ((OPTARG < COLORS)); then
                C+=($OPTARG)
            else
                pearg "must be an integer and from 0 to $((COLORS - 1));" \
                      'or a hexadecimal string with # prefix'
                return 1
            fi
            ;;
        f)
            if is_N "$OPTARG" && ((OPTARG >= 20 && OPTARG <= 100)); then
                f=$OPTARG
            else
                pearg 'must be an integer and from 20 to 100'
                return 1
            fi
            ;;
        s)
            if is_N "$OPTARG" && ((OPTARG >= 5 && OPTARG <= 15)); then
                s=$OPTARG
            else
                pearg 'must be an integer and from 5 to 15'
                return 1
            fi
            ;;
        r)
            if is_N "$OPTARG"; then
                r=$OPTARG
            else
                pearg 'must be a non-negative integer'
                return 1
            fi
            ;;
        R) RNDSTART=1;;
        B) BOLD=0;;
        C) NOCOLOR=1;;
        K) KEEPCT=1;;
        h)
            print_help
            exit 0
            ;;
        v) echo "$(basename -- "$0") $VERSION"
            exit 0
            ;;
        *)
            return 1
        esac
    done

    shift $((OPTIND - 1))
    if (($#)); then
        printf "$0: illegal arguments -- $*; no arguments allowed\n" >&2
        return 1
    fi
}


cleanup() {
    # clear out standard input
    read -t 0.001 && cat </dev/stdin>/dev/null

    tput reset  # fix for konsole, see pipeseroni/pipes.sh#43
    tput rmcup
    tput cnorm
    stty echo
    printf "$SGR0"
    exit 0
}


resize() {
    w=$(tput cols) h=$(tput lines)
}


init_pipes() {
    # +_CP_init_pipes
    local i

    ci=$((KEEPCT ? 0 : CN * RANDOM / M))
    vi=$((KEEPCT ? 0 : VN * RANDOM / M))
    for ((i = 0; i < p; i++)); do
        ((
            n[i] = 0,
            l[i] = RNDSTART ? RANDOM % 4 : 0,
            x[i] = RNDSTART ? w * RANDOM / M : w / 2,
            y[i] = RNDSTART ? h * RANDOM / M : h / 2,
            v[i] = V[vi]
        ))
        c[i]=${E[ci]}
        ((ci = (ci + 1) % CN, vi = (vi + 1) % VN))
    done
    # -_CP_init_pipes
}


init_screen() {
    stty -echo
    tput smcup
    tput civis
    tput clear
    trap cleanup HUP TERM

    resize
    trap resize SIGWINCH
}


main() {
    # simple pre-check of TERM, tput's error message should be enough
    tput -T "$TERM" sgr0 >/dev/null || return $?

    # +_CP_init_termcap_vars
    COLORS=$(tput colors)  # COLORS - 1 == maximum color index for -c argument
    SGR0=$(tput sgr0)
    SGR_BOLD=$(tput bold)
    # -_CP_init_termcap_vars

    parse "$@" || return $?

    # +_CP_init_VC
    # set default values if not by options
    ((${#V[@]})) || V=(0)
    VN=${#V[@]}
    ((${#C[@]})) || C=(1 2 3 4 5 6 7 0)
    CN=${#C[@]}
    # -_CP_init_VC

    # +_CP_init_E
    # generate E[] based on BOLD (SGR_BOLD), NOCOLOR, and C for each element in
    # C, a corresponding element in E[] =
    #   SGR0
    #   + SGR_BOLD, if BOLD
    #   + tput setaf C, if !NOCOLOR
    local i
    for ((i = 0; i < CN; i++)) {
        E[i]=$SGR0
        ((BOLD))    && E[i]+=$SGR_BOLD
        ((NOCOLOR)) || E[i]+=$(tput setaf ${C[i]})
    }
    # -_CP_init_E

    # +_CP_init_SETS
    local i j
    for ((i = 0; i < ${#sets[@]}; i++)) {
        for ((j = 0; j < 16; j++)) {
            SETS+=("${sets[i]:j:1}")
        }
    }
    unset i j
    # -_CP_init_SETS

    init_screen
    init_pipes

    # any key press exits the loop and this script
    trap 'break 2' INT

    local i
    while REPLY=; do
        read -t 0.0$((1000 / f)) -n 1 2>/dev/null
        case "$REPLY" in
            P) ((s = s <  15 ? s + 1 : s));;
            O) ((s = s >   3 ? s - 1 : s));;
            F) ((f = f < 100 ? f + 1 : f));;
            D) ((f = f >  20 ? f - 1 : f));;
            B) ((BOLD = (BOLD + 1) % 2));;
            C) ((NOCOLOR = (NOCOLOR + 1) % 2));;
            K) ((KEEPCT = (KEEPCT + 1) % 2));;
            ?) break;;
        esac
        for ((i = 0; i < p; i++)); do
            # New position:
            # l[] direction = 0: up, 1: right, 2: down, 3: left
            # +_CP_newpos
            ((l[i] % 2)) && ((x[i] += -l[i] + 2, 1)) || ((y[i] += l[i] - 1))
            # -_CP_newpos

            # Loop on edges (change color on loop):
            # +_CP_warp
            ((!KEEPCT && (x[i] >= w || x[i] < 0 || y[i] >= h || y[i] < 0))) \
            && { c[i]=${E[CN * RANDOM / M]}; ((v[i] = V[VN * RANDOM / M])); }
            ((x[i] = (x[i] + w) % w,
              y[i] = (y[i] + h) % h))
            # -_CP_warp

            # new turning direction:
            # $((s - 1)) in $s, going straight, therefore n[i] == l[i];
            # and 1 in $s that pipe makes a right or left turn
            #
            #     s * RANDOM / M - 1 == 0
            #     n[i] == -1
            #  => n[i] == l[i] + 1 or l[i] - 1
            # +_CP_newdir
            ((
                n[i] = s * RANDOM / M - 1,
                n[i] = n[i] >= 0 ? l[i] : l[i] + (2 * (RANDOM % 2) - 1),
                n[i] = (n[i] + 4) % 4
            ))
            # -_CP_newdir

            # Print:
            # +_CP_print
            printf '\e[%d;%dH%s%s'                      \
                   $((y[i] + 1)) $((x[i] + 1)) ${c[i]}  \
                   "${SETS[v[i] * 16 + l[i] * 4 + n[i]]}"
            # -_CP_print
            l[i]=${n[i]}
        done
        ((r > 0 && t * p >= r)) && tput reset && tput civis && t=0 || ((t++))
    done

    cleanup
}


# when being sourced, $0 == bash, only invoke main when they are the same
[[ "$0" != "$BASH_SOURCE" ]] ||  main "$@"
