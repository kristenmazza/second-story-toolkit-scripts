#!/bin/bash

set -o errexit

IMAGES=home-safety-problems-images.txt
OUTPUT=output
WATERMARK='© 2nd Story Toolkit'

stamp() {
  # generate watermark 
  mkdir -p stamp
  pushd stamp || return
  convert -size 600x100 xc:grey30 -font Arial -pointsize 40 -gravity center \
    -draw "fill grey70  text 0,0  '$WATERMARK'" \
    stamp_fgnd.png
  convert -size 600x100 xc:black -font Arial -pointsize 40 -gravity center \
    -draw "fill white  text  1,1  '$WATERMARK'  \
                                text  0,0  '$WATERMARK'  \
                    fill black  text -1,-1 '$WATERMARK'" \
    +matte stamp_mask.png
  composite -compose CopyOpacity stamp_mask.png stamp_fgnd.png stamp.png
  mogrify -trim +repage stamp.png
  popd || return
}

watermark() {
  filename=$1
  composite -gravity southeast -geometry +0+10 stamp/stamp.png  "$filename" "$filename"
}

number() {
  filename=$1
  number=$2
  output="$OUTPUT"/"$number".jpeg
  convert "$filename" -gravity SouthWest -pointsize 250 -fill black -annotate 0 "$number" "$output"
  echo "$output"
}

# generate stamp file
stamp

mkdir -p "$OUTPUT"

while IFS= read -r line; do
  : $((counter = counter + 1))
  echo $counter
  # file "$line"
  output=$(number "$line" "$counter")
  watermark "$output"
done <$IMAGES
