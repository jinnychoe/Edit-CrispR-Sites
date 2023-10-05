#!/bin/bash

# Create a directory to store edited CRISPR results
mkdir -p postCRISPR

# Loop through each preCRISPR FASTA file in the precrispr folder
for input in preCRISPR/*.fasta; do

    # Get the name of the organism from the exome file
    exomeName=$(basename "$input" _precrispr.fasta)

    # Output file for the edited CRISPR FASTA file
    output="postCRISPR/${exomeName}_postcrispr.fasta"

    # Insert Adenine before NGG site using sed. Save to output file
    sed 's/[ATGC]GG/A&/g' "$input" > "$output"

done

echo "An Adenine nucleotide has been inserted before all 'NGG' (N is any nucleotide) patterns in the CRISPR sites of the '{exomeName}_preCRISPR.fasta' file."
echo " "
echo "Header and sequences of genes with edited CRISPR sites have been saved to '{exomeName}_postcrispr.fasta' in the 'postCRISPR' directory."
echo " "

