#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is required but not found. Please install it first."
    exit 1
fi

# Find and process all image files recursively
find . -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" \) -exec sh -c '
    for file do
        echo "Processing: $file"
        
        r=$(od -An -N1 -tu1 < /dev/urandom)
        g=$(od -An -N1 -tu1 < /dev/urandom)
        b=$(od -An -N1 -tu1 < /dev/urandom)
        
        convert -size 1x1 xc:"rgb($r,$g,$b)" "$file"
        
        exiftool -overwrite_original -TagsFromFile @ -all:all "$file" >/dev/null 2>&1
    done
' sh {} +

echo "All images have been replaced with visible 1x1 pixels of random colors."
