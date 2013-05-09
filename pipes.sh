#!/bin/bash
# The author of the original script is unknown to me. The first entry I can
# find was posted at 2010-03-21 09:50:09 on Arch Linux Forums (doesn't mean the
# poster is the author at all):
#
#   https://bbs.archlinux.org/viewtopic.php?pid=728932#p728932
#
# I, Yu-Jie Lin, made a few changes and additions:
#
#   -p, -t, -R, and -C
#
#   Screenshot: http://flic.kr/p/dRnLVj
#   Screencast: http://youtu.be/5XnGSFg_gTk
#
# And push the commits to Gist:
#
#   https://gist.github.com/4689307
#
# I, Devin Samarin, made a few changes and additions:
#
#   -r can be 0 to mean "no limit".
#   Reset cursor visibility after done.
#   Cleanup for those people who want to quit with ^C
#
#   Pushed the changes to https://gist.github.com/4725048

p=1
f=75 s=13 r=2000 t=0
w=$(tput cols) h=$(tput lines)
# ab -> idx = a*4 + b
# 0: up, 1: right, 2: down, 3: left
# 00 means going up   , then going up   -> ┃
# 12 means going right, then going down -> ┓
sets=(
    "┃┏ ┓┛━┓  ┗┃┛┗ ┏━"
    "│╭ ╮╯─╮  ╰│╯╰ ╭─"
    "│┌ ┐┘─┐  └│┘└ ┌─"
    "║╔ ╗╝═╗  ╚║╝╚ ╔═"
)
v="${sets[0]}"
RNDSTART=0
NOCOLOR=0

OPTIND=1
while getopts "p:t:f:s:r:RCh" arg; do
case $arg in
    p) ((p=(OPTARG>0)?OPTARG:p));;
    t) ((OPTARG>=0 && OPTARG<${#sets[@]})) && v="${sets[OPTARG]}";;
    f) ((f=(OPTARG>19 && OPTARG<101)?OPTARG:f));;
    s) ((s=(OPTARG>4 && OPTARG<16 )?OPTARG:s));;
    r) ((r=(OPTARG>=0)?OPTARG:r));;
    R) RNDSTART=1;;
    C) NOCOLOR=1;;
    h) echo -e "Usage: $(basename $0) [OPTION]..."
        echo -e "Animated pipes terminal screensaver.\n"
        echo -e " -p [1-]\tnumber of pipes (D=1)."
        echo -e " -t [0-$((${#sets[@]} - 1))]\ttype of pipes (D=0)."
        echo -e " -f [20-100]\tframerate (D=75)."
        echo -e " -s [5-15]\tprobability of a straight fitting (D=13)."
        echo -e " -r LIMIT\treset after x characters, 0 if no limit (D=2000)."
        echo -e " -R \t\trandom starting point."
        echo -e " -C \t\tno color."
        echo -e " -h\t\thelp (this screen).\n"
        exit 0;;
    esac
done

cleanup() {
    tput rmcup
    tput cnorm
    exit 0
}
trap cleanup SIGHUP SIGINT SIGTERM

for (( i=1; i<=p; i++ )); do
    c[i]=$((i%8)) n[i]=0 l[i]=0
    ((x[i]=RNDSTART==1?RANDOM*w/32768:w/2))
    ((y[i]=RNDSTART==1?RANDOM*h/32768:h/2))
done

tput smcup
tput reset
tput civis
while ! read -t0.0$((1000/f)) -n1; do
    for (( i=1; i<=p; i++ )); do
        # New position:
        ((${l[i]}%2)) && ((x[i]+=-${l[i]}+2,1)) || ((y[i]+=${l[i]}-1))

        # Loop on edges (change color on loop):
        ((${x[i]}>w||${x[i]}<0||${y[i]}>h||${y[i]}<0)) && ((c[i]=RANDOM%8))
        ((x[i]=(x[i]+w)%w))
        ((y[i]=(y[i]+h)%h))

        # New random direction:
        ((n[i]=RANDOM%s-1))
        ((n[i]=(${n[i]}>1||${n[i]}==0)?${l[i]}:${l[i]}+${n[i]}))
        ((n[i]=(${n[i]}<0)?3:${n[i]}%4))

        # Print:
        tput cup ${y[i]} ${x[i]}
        [[ $NOCOLOR == 0 ]] && echo -ne "\033[1;3${c[i]}m"
        echo -n "${v:l[i]*4+n[i]:1}"
        l[i]=${n[i]}
    done
    ((r>0 && t*p>=r)) && tput reset && tput civis && t=0 || ((t++))
done

cleanup
