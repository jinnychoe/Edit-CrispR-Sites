#!/bin/bash

# Create a directory to store top motifs FASTA files
mkdir -p topMotifs

# Read the motif_list.txt file and save motifs into an array
motifArray=()
while IFS= read -r motif; do
    motifArray+=("$motif")
done < motif_list.txt

# Loop through each exome FASTA file in exomesCohort directory
for fasta in exomesCohort/*.fasta; do
    # echo "Processing exome: $fasta"

    # Get the name of the organism from the exome file
    name=$(basename "$fasta" .fasta)

    # Create an array to store motif counts for the exome file
    declare -A motifCountDict

    # Count the number of occurrences of each motifs in the exome and save the count in a dictionary
    for ((i = 0; i < ${#motifArray[@]}; i++)); do
        motif="${motifArray[$i]}"
        count=$(grep -oF "$motif" "$fasta" | wc -l)
        motifCountDict["$motif"]=$count
    done

    # Sort motifs based on counts in descending order and get the top 3 motifs
    sorted_motifs=()
    for motif in "${!motifCountDict[@]}"; do
        sorted_motifs+=("$motif ${motifCountDict[$motif]}")
    done
    IFS=$'\n' sorted_motifs=($(sort -k2,2nr <<<"${sorted_motifs[*]}"))
    unset IFS
    top_3motifs=("${sorted_motifs[@]:0:3}")

    # Print the top 3 motifs for this exome with their counts
    echo "Top motifs for exome $name.fasta:"
    for motif in "${top_3motifs[@]}"; do
        motif=$(echo "$motif" | awk '{print $1}') # Extract motif from the sorted_motifs
        count=${motifCountDict["$motif"]}
        echo "$motif (Count: $count)"
    done

    # Output headers and sequences that have top 3 motifs to the output file in topMotifs folder
    output="topMotifs/${name}_topmotifs.fasta"
    > "$output"

    
    while read -r header; do  # Use while loop to process the gene headers and sequences 
        read -r sequence # Gene sequence is the line after gene header
     
        for motif in "${top_3motifs[@]}"; do    # Check if any of the top motifs are present in the gene sequence
            motif=$(echo "$motif" | awk '{print $1}') # Extract motif from the sorted_motifs
            
            if [[ "$sequence" == *"$motif"* ]]; then
                # Copy gene header and sequence if contains top 3 motif
                echo "$header" >> "$output"
                echo "$sequence" >> "$output"
                break
            fi
            
        done
        
    done < "$fasta"

    echo
done

echo "Motifs searched for in exomes FASTA files in 'exomeCohort' directory."
echo " "
echo "The top 3 motifs for each exome were determined."
echo " "
echo "Headers and sequences of genes that contain the top three motifs have been saved to '{exomename}_topMotifs.fasta' in the 'topMotifs' directory."
echo " "

