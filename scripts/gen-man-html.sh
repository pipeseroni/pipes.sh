#!/usr/bin/env bash


groff -mandoc -Thtml < "$1" |
sed \
    -e '/<!DOCTYPE/ i\
<!-- Modified By : pipes.sh Makefile -->' \
    -e '/<!DOCTYPE/ i\
<!-- Modified At : '"$(date)"' -->' \
    -e '/<meta name="generator"/ s/">/; pipes.sh Makefile&/' \
    -e '/<style/ a\
       body  { font-family: monospace; width: 79ch; margin: auto auto }' \
> "$2"
