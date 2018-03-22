#!/usr/bin/env bash

# get manpage date and version strings
read date <<< "$(sed -n -E -e '/\.TH/ s/^[^"]+"([^"]+)".*/\1/p' < "$1")"
read ver  <<< "$(sed -n -E -e '/\.TH/ s/^[^"]+"[^"]+" "([^"]+)".*/\1/p' < "$1")"


groff -mandoc -Thtml < "$1" |
sed \
    -e '/<!DOCTYPE/ i\
<!-- Modified By : pipes.sh Makefile -->' \
    -e '/<!DOCTYPE/ i\
<!-- Modified At : '"$(date)"' -->' \
    -e '/<meta name="generator"/ s/">/; pipes.sh Makefile&/' \
    -e '/<style/ a\
       body  { font-family: monospace; width: 79ch; margin: auto auto }' \
    -e '/<h1/ a\
<pre>Version: '"$ver"'<br>Date   : '"$date"'</pre><hr>' \
> "$2"
