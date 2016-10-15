#!/bin/bash

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-f OUTFILE] [FILE]...
Do stuff with FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

    -h          display this help and exit
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
EOF
}

VERBOSE=0
LOGO="res/stamp_6x13.png"

OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.
while getopts "hvi:" opt; do
    case "$opt" in
        h)  show_help
            exit 0
            ;;
        v)  VERBOSE=$((VERBOSE+1))
            ;;
        i)  INPUT=$OPTARG
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

MAGICK_OCL_DEVICE=OFF

BASENAME=$(basename "$INPUT")
FILENAME="${BASENAME##*/}"
HASH=$(md5sum <<< "$FILENAME" | awk '{print substr($1,0,6)}')

mkdir -p $HASH

convert -antialias -size 512x320 stamp_bg.png \
        -stroke none -fill "#$HASH" \
        -draw "rectangle 208,80 304,176" \
        -font Shortcut -fill '#503050' \
        -pointsize 50 -gravity south \
        -draw "text 0,0 '#$HASH'" \
        "$HASH/images/stamp.png"

pandoc -f markdown -t latex \
       --latex-engine=xelatex \
       --latex-engine-opt="--shell-escape" \
       --latex-engine-opt="--enable-write18" \
       --template tldrt.latex \
       --variable hash="$HASH"
       -o "$HASH/${FILENAME}.pdf" "${BASENAME}"

pandoc -f markdown -t html \
       --template tldrt.html \
       --variable hash="$HASH"
       -o "$HASH/${FILENAME}.html" "${BASENAME}"

convert -antialias -density 240 "$HASH/${FILENAME}.pdf[0]" \
        -quality 90 -gravity north \
        -crop 1200x642+0+160 +repage \
        -resize 50% -flatten \
        images/vignette.png \
        -compose ColorBurn -composite \
        "$HASH/thumbnail.png"

# End of file
