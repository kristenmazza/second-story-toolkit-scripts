# Second Story Toolkit Scripts

Scripts in this repository have been created to assist with compiling new teaching materials.

## Image Generation

This script will add a sequential number to each image, as well as a watermark for Second Story Toolkit.

### Prerequistes

1. `imagemagick` command line tool
2. Roboto family of fonts (Roboto-Bold and Roboto-Bold-Italic) installed on system

### Usage

1. List full paths of the images to watermark and number them in `home-safety-problems-images.txt`.
2. Run script from terminal with `$ sh generate-images.sh` (from within hame-safety-problem-images directory).
3. View watermarked and numbered images in the `output` directory.
