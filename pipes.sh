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


VERSION=1.2.0

M=32768
p=1
f=75 s=13 r=2000 t=0
w=80 h=24

# ab -> idx = a*4 + b
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
v=()
RNDSTART=0
BOLD=1
NOCOLOR=0
KEEPCT=0  # Keep pipe color and type


parse() {
    OPTIND=1
    while getopts "p:t:c:f:s:r:RBCKhv" arg; do
    case $arg in
        p) ((p = (OPTARG > 0) ? OPTARG : p));;
        t)
            if [[ "$OPTARG" = c???????????????? ]]; then
                V+=(${#sets[@]})
                sets+=("${OPTARG:1}")
            else
                ((OPTARG >= 0 && OPTARG < ${#sets[@]})) && V+=($OPTARG)
            fi
            ;;
        c) [[ $OPTARG =~ ^[0-7]$ ]] && C+=($OPTARG);;
        f) ((f = (OPTARG > 19 && OPTARG < 101) ? OPTARG : f));;
        s) ((s = (OPTARG > 4 && OPTARG < 16) ? OPTARG : s));;
        r) ((r = (OPTARG >= 0) ? OPTARG : r));;
        R) RNDSTART=1;;
        B) BOLD=0;;
        C) NOCOLOR=1;;
        K) KEEPCT=1;;
        h) echo -e "Usage: $(basename $0) [OPTION]..."
            echo -e "Animated pipes terminal screensaver.\n"
            echo -e " -p [1-]\tnumber of pipes (D=1)."
            echo -e " -t [0-$((${#sets[@]} - 1))]\ttype of pipes, can be used more than once (D=0)."
            echo -e " -c [0-7]\tcolor of pipes, can be used more than once (D=1 2 3 4 5 6 7 0)."
            echo -e " -t c[16 chars]\tcustom type of pipes."
            echo -e " -f [20-100]\tframerate (D=75)."
            echo -e " -s [5-15]\tprobability of a straight fitting (D=13)."
            echo -e " -r LIMIT\treset after x characters, 0 if no limit (D=2000)."
            echo -e " -R \t\trandom starting point."
            echo -e " -B \t\tno bold effect."
            echo -e " -C \t\tno color."
            echo -e " -K \t\tpipes keep their color and type when hitting the screen edge."
            echo -e " -h\t\thelp (this screen)."
            echo -e " -v\t\tprint version number.\n"
            exit 0;;
        v) echo "$(basename -- "$0") $VERSION"
            exit 0
        esac
    done

    # set default values if not by options
    ((${#V[@]})) || V=(0)
    VN=${#V[@]}
    ((${#C[@]})) || C=(1 2 3 4 5 6 7 0)
    CN=${#C[@]}
}


cleanup() {
    # clear up standard input
    read -t 0.001 && cat </dev/stdin>/dev/null

    # terminal has no smcup and rmcup capabilities
    ((FORCE_RESET)) && reset && exit 0

    tput reset  # fix for konsole, see pipeseroni/pipes.sh#43
    tput rmcup
    tput cnorm
    stty echo
    ((NOCOLOR)) && echo -ne '\x1b[0m'
    exit 0
}


resize() {
    w=$(tput cols) h=$(tput lines)
}


init() {
    local i

    resize
    trap resize SIGWINCH
    ci=$((KEEPCT ? 0 : CN * RANDOM / M))
    vi=$((KEEPCT ? 0 : VN * RANDOM / M))
    for ((i = 1; i <= p; i++)); do
        n[i]=0
        l[i]=0
        ((x[i] = RNDSTART == 1 ? w * RANDOM / M : w / 2))
        ((y[i] = RNDSTART == 1 ? h * RANDOM / M : h / 2))
        c[i]=${C[ci]}
        ((ci = (ci + 1) % CN))
        v[i]=${V[vi]}
        ((vi = (vi + 1) % VN))
    done

    stty -echo
    tput smcup || FORCE_RESET=1
    tput civis
    tput clear
    trap cleanup HUP TERM
}


main() {
    local i

    parse "$@"
    init "$@"

    # any key press exits the loop and this script
    trap 'break 2' INT
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
        for ((i = 1; i <= p; i++)); do
            # New position:
            ((l[i] % 2)) && ((x[i] += -l[i] + 2, 1)) || ((y[i] += l[i] - 1))

            # Loop on edges (change color on loop):
            ((!KEEPCT && (x[i] >= w || x[i] < 0 || y[i] >= h || y[i] < 0))) \
            && ((c[i] = C[CN * RANDOM / M], v[i] = V[VN * RANDOM / M]))
            ((x[i] = (x[i] + w) % w))
            ((y[i] = (y[i] + h) % h))

            # New random direction:
            ((n[i] = s * RANDOM / M - 1))
            ((n[i] = (n[i] > 1 || n[i] == 0) ? l[i] : l[i] + n[i]))
            ((n[i] = (n[i] < 0) ? 3 : n[i] % 4))

            # Print:
            tput cup ${y[i]} ${x[i]}
            echo -ne "\x1b[${BOLD}m"
            ((NOCOLOR)) && echo -ne "\x1b[0m" || echo -ne "\x1b[3${c[i]}m"
            echo -n "${sets[v[i]]:l[i]*4+n[i]:1}"
            l[i]=${n[i]}
        done
        ((r > 0 && t * p >= r)) && tput reset && tput civis && t=0 || ((t++))
    done

    cleanup
}


main "$@"
