# Create a directory to store the final preCRISPR results
mkdir -p preCRISPR

# Loop goes through each exome_topmotifs.fasta file in topMotifs folder
for fasta in topMotifs/*_topmotifs.fasta; do

    # Gets exomeName from exome FASTA file
    exomeName=$(basename "$fasta" _topmotifs.fasta)

    # Output file for final CRISPR results
    output="preCRISPR/${exomeName}_precrispr.fasta"

    num_genes=0 # Initialize counter

    while read -r header; do # Use while loop to process the gene headers and sequences
        read -r sequence # Gene sequence is the line after gene header

        if [[ "$sequence" =~ .*[ACGT]{21}GG.* ]]; then # Check for occurrence of "GG" after any 21 nucleotides
            num_genes=$((num_genes + 1))
            echo "$header" >> "$output" # Copy gene header and sequence if contains CRISPR site
            echo "$sequence" >> "$output"
        fi
    done < "$fasta"

    # Print the total number of CRISPR sites in each {exomename}_topmotifs.fasta file
    echo "Total number of CRISPR sites in $exomeName""_topmotifs.fasta: $num_genes"
    echo " "
done

echo "Possible CRISPR sites have been identified."
echo " "
echo "Header and sequences of genes that contain CRISPR sites have been saved to '{exomename}_precrispr.fasta' in the 'preCRISPR' directory."

