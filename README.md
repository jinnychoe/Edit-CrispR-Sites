Identifying and modifying CRISPR sites in genes  
===============================================
This repository contains a collection of bash scripts and python programs used to process genomic data in FASTA files. The scripts have been validated to run on Linux systems to determine genes that contain target motifs, determine possible CRISPR sites in genes, edit nucleotide sequence at CRISPR sites, and summarize the data in a report.  
 
About 
-------
1. The `copyExomes.sh` script reads data in the `clinical_data.txt` file in the working directory. The script identifies target exomes that have a diameter that is between 20 to 30 mm long and have genomes that are sequenced. The exomes that meet this requirement are copied from the `exome` directory to the `exomesCohort` directory.  
 
2. The `createCrisprReady.sh` script counts the number of times each motif from the `motif_list.txt` file in the working directory occurs in each exome FASTA file in the `exomesCohort` directory. Then it determines the three motifs that occur the highest number of times in that exome. It searches for the genes that contain at least one of these three motifs. Finally, it copies the gene header and sequence to the `{exomeName}_topmotifs.fasta` file in the `topMotifs` directory.   
 
3. The `identifyCrisprSite.sh` script searches for a suitable CRISPR site in each gene in the `{exomeName}_topmotifs.fasta` file in the `topMotifs` directory. A suitable CRISPR site consists of 20 nucleotides followed by the NGG nucleotide site, where N is any nucleotide. The gene headers and sequences with suitable CRISPR sites are copied to a temporary file. The `{exomeName}_precrispr.fasta` file contains the gene headers and sequences without duplicate entries in the `preCRISPR` directory.   
 
4. The `editGenome.sh` script edits the CRISPR site in each gene in the `{exomeName}_precrispr.fasta` file in the `preCRISPR` directory. An adenine nucleotide is added before the NGG nucleotide site. The gene headers and sequence with the edited CRISPR site are saved to `{exomeName}_postcrispr.fasta` file in the `postCRISPR` directory.  
 
5. The `exomeReport.py` script creates a report that summarizes data about the exomes that were selected by `copyExomes.sh`. It also finds the union of the genes across the exomes in the `preCRISPR` directory. It summarizes the total number of genes in the union.   
 
Execute the scripts in Ubunutu/Linux
---------------------------------------------
1. The `copyExomes.sh`, `createCrisprReady.sh`, `identifyCrisprSite.sh`, `editGenome.sh`, and `exomeReport.py` scripts should be located in the working directory  
 
The `clinical_data.txt` and `motif_list.txt` and `exomes` directory should be located in the working directory.  
 
The exome FASTA files should be located in the `exomes` directory.   
 
2. Give the scripts executable permissions using the following commands:  
 
chmod +x copyExomes.sh  
chmod +x createCrisprReady.sh  
chmod +x identifyCrisprSite.sh  
chmod +x editGenome.sh  
chmod +x exomeReport.py  
 
3. Execute the script with the following command:  
 
./copyExomes.sh  
./createCrisprReady.sh  
./identifyCrisprSite.sh  
./editGenome.sh  
./exomeReport.py  
 
4. The following outputs will be generated:  
 
The `copyExomes.sh` script will copy identified exome FASTA files to the `exomesCohort` directory.  
 
The `createCrisprReady.sh` script will identify the top three motifs that each exome contains, then it will copy the genes with those top three motifs to the `{exomeName}_topMotifs.fasta` file in the `topMotifs` directory.  
 
The `identifyCrisprSite.sh` script will determine which genes contain suitable CRISPR sites, then it will copy those genes to the `{exomeName}_precrispr.fasta` file in the `preCRISPR` directory.  
 
The `editGenome.sh` script will add an Adenine nucleotide to the NGG nucleotide in the CRISPR sites. The output will be saved to the `{exomeName}_postcrispr.fasta` file in `postCRISPR` directory.  
 
The `exomeReport.py` script will summarize the characteristics of the exomes that were selected by the copyExomes.sh script. The output will be saved to `summary_data.txt` in working directory.   

 
