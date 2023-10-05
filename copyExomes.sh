#!/bin/bash

# Create a directory to save exome files
mkdir -p exomesCohort

# Use awk to read each line in clinical_data.txt
# Use tabs as deliminator and find sequenced samples
# Skip the first row
# Check 3rd field if diameter is between 20 - 30 mm
# Check 5th field if the exome is sequenced
# Create a path to target exome file. Use 6th field as name of fasta file
# Copy exome file to exomeCohort dir
awk -F'\t' \
'NR > 1 \
&& $3 >= 20 && $3 <= 30 \
&& $5 == "Sequenced" \
{ 
    exome_file = "exomes/" $6 ".fasta"; \
    system("cp \"" exome_file "\" exomesCohort/"); \
    print $6 ".fasta has been copied from /exomes to /exomesCohort." 
    print " "
}' \
clinical_data.txt

echo "Exomes for the selected samples have been copied to the 'exomesCohort' directory."

