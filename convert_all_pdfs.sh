#!/bin/zsh

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 /path/to/input/directory /path/to/output/directory"
  exit 1
fi

# Input and output directories
input_dir="$1"
output_dir="$2"

# Ensure output directory exists
mkdir -p "$output_dir"

# Desired crop area (width and height in pixels for 4x6 aspect ratio)
dpi=300

# Loop through each PDF file in the input directory
for pdf_file in "$input_dir"/*.pdf; do
  # Check if there are any PDF files in the directory
  if [ ! -e "$pdf_file" ]; then
    echo "No PDF files found in the directory."
    exit 1
  fi
  
  #lx=$(gs -q -dBATCH -dNOPAUSE -sDEVICE=bbox -dLastPage=1 $pdf_file 2>&1 | grep %%BoundingBox | awk '{print $2}')
  #ly=$(gs -q -dBATCH -dNOPAUSE -sDEVICE=bbox -dLastPage=1 $pdf_file 2>&1 | grep %%BoundingBox | awk '{print $3}')
  #echo $lx $ly
  # rx=$(gs -q -dBATCH -dNOPAUSE -sDEVICE=bbox -dLastPage=1 pubs/aslam_grl_2021.pdf 2>&1 | grep %%BoundingBox | awk '{print $4}')
  # ry=$(gs -q -dBATCH -dNOPAUSE -sDEVICE=bbox -dLastPage=1 pubs/aslam_grl_2021.pdf 2>&1 | grep %%BoundingBox | awk '{print $5}')
  
  # Get the base name of the PDF file (without path and extension)
  base_name=$(basename "$pdf_file" .pdf)

  # Define the output PNG file path
  output_png="$output_dir/${base_name}.png"

  # Convert the first page of the PDF to a cropped grayscale PNG image
  #gs -dBATCH -dNOPAUSE -sDEVICE=pnggray -dFirstPage=1 -dLastPage=1 -r$dpi -g1800x1200 -sOutputFile="$output_png" "$pdf_file"
  gs -dBATCH -dNOPAUSE -sDEVICE=png16m -dFirstPage=1 -dLastPage=1 -r$dpi -sOutputFile="$output_png" -f "$pdf_file"
  
  echo "Processed $pdf_file -> $output_png"
done
