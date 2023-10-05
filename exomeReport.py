#!/usr/bin/env python3
import os
import csv

# Function to check if a file exists
def fileExists(filename):
    return os.path.exists(filename)

# Function to read gene numbers from headers from the corresponding preCRISPR file
def getGeneNum(exomeName):
    exome = os.path.join("preCRISPR", f"{exomeName.lower()}_precrispr.fasta") # Create path to precrispr.fasta file
    with open(exome, 'r') as fasta_file: # Opens precrispr.fasta file for reading
        geneNumList = [int(line.strip()[5:]) for line in fasta_file if line.startswith(">")] # Reads line if starts with > and stores gene number in list
        return sorted(geneNumList) # Return list of gene numbers 

# Opens the clinical data file for reading
with open('clinical_data.txt', 'r') as data_file:
    reader = csv.reader(data_file, delimiter='\t') # Use tab as delimiter
    next(reader)  # Skip the header row

    # Creates a list to store selected organisms' information
    selectedOrganisms = []

    # Creates a dictionary to store gene numbers for each exome
    geneNumDict = {}

    # Processes each line
    for row in reader:
        discoverer, location, diameter, environment, status, exomeName = map(str.upper, row)

        # Checks if diameter is between 20 - 30 mm and the exome is sequenced
        if 20 <= int(diameter) <= 30 and status == "SEQUENCED":
            fasta_file = f"preCRISPR/{exomeName.lower()}_precrispr.fasta" # Create path to precrispr.fasta file
            if fileExists(fasta_file): # Checks if preCRISPR file exists
                selectedOrganisms.append(  # Appends the information about the selected organism to the list
                    f"Organism {exomeName}, discovered by {discoverer}, has a diameter of {diameter} mm, and from the environment {environment}.\n"
                )
                geneNumDict[exomeName] = getGeneNum(exomeName) # Get gene numbers for the current exome and store them in the geneNumDict dictionary

# Writes information to a text file
with open('summary_report.txt', 'w') as output:
    for organismInfo in selectedOrganisms:
        output.write(organismInfo + '\n')



print("A report has been generated and saved to 'summary_report.txt'.")

