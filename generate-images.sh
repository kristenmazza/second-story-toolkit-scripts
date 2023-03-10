#!/bin/bash

set -o errexit

IMAGES=home-safety-problems-images.txt
OUTPUT=output
WATERMARK='© 2nd Story Toolkit'
SIZE='2550x2550'  # '3400x2550'

stamp() {
  # generate watermark
  # see https://amytabb.com/til/photography/2021/01/23/image-magick-watermark/ for reference
  mkdir -p stamp
  pushd stamp || return
  convert -size 1800x300 xc:transparent -font "Roboto-Bold-Italic" -pointsize 100 -gravity center \
      -fill black        -annotate +24+64 "$WATERMARK" \
      -fill white        -annotate +26+66 "$WATERMARK" \
      -fill transparent  -annotate +25+65 "$WATERMARK" \
    stamp_fgnd.png
  convert -size 1800x300 xc:black -font "Roboto-Bold-Italic" -pointsize 100 -gravity center \
      -fill white   -annotate +24+64 "$WATERMARK" \
      -fill white   -annotate +26+66 "$WATERMARK" \
      -fill black   -annotate +25+65 "$WATERMARK" \
    stamp_mask.jpg
  composite -compose CopyOpacity stamp_mask.jpg stamp_fgnd.png stamp.png
  mogrify -trim +repage stamp.png
  popd || return
}

resize() {
  filename=$1
  number=$2
  output="$OUTPUT"/"$number".jpeg
  convert "$filename" \
      -resize "$SIZE" \
    "$output"
  echo "$output"
}

watermark() {
  filename=$1
  composite \
      -gravity southeast \
      -geometry +40+30 stamp/stamp.png "$filename" \
    "$filename"
}

number() {
  filename=$1
  number=$2
  convert "$filename" \
      -font "Roboto-Bold" \
      -pointsize 100 \
      -gravity SouthWest \
      -fill black -annotate +40+30 "$number" \
    "$filename"
}

border() {
  filename=$1
  convert "$filename" \
      -bordercolor '#FFFFFF' \
      -border 20 \
      -bordercolor '#000000' \
      -border 10 \
    "$filename"
}

# generate stamp file
stamp

mkdir -p "$OUTPUT"

while IFS= read -r line; do
  : $((counter = counter + 1))
  echo $counter
  # file "$line"
  output=$(resize "$line" "$counter")
  number "$output" "$counter"
  watermark "$output"
  border "$output"
done <$IMAGES
