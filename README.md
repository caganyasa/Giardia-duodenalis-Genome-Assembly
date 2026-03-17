# Giardia duodenalis Genome Assembly

A hands-on genome assembly project focused on debugging and pipeline optimization.

This project presents a genome assembly and evaluation workflow using Oxford Nanopore long-read data.

The main objective was not only to run an existing pipeline, but to understand, debug, and adapt it into a working and reproducible workflow.

---

## Organism and Dataset

- Species: Giardia duodenalis  
- SRA Accession: SRR22286255  
- Platform: Oxford Nanopore (MinION)  
- Data size: ~857 Mb  

This dataset was selected due to its manageable genome size and suitability for long-read assembly.

---

## Reference Genome

- Accession: GCF_000002435.2  
- Organism: Giardia duodenalis WB (Assemblage A)  

This reference was used for assembly evaluation and comparison.

---

## Pipeline Overview

The workflow is based on a modified version of the GenoDiplo Snakemake pipeline.

Final structure:

FASTQ → Flye → QUAST

The original pipeline contained additional modules such as annotation, repeat masking, and orthology analysis. These were removed to ensure the pipeline could run reliably in a local environment.

---

## Key Modifications

- Replaced hardcoded paths with configurable inputs  
- Simplified the Snakemake workflow  
- Removed unused and computationally heavy modules  
- Fixed Flye output structure mismatch  
- Built a minimal conda environment  
- Adjusted rule dependencies  

---

## Challenges and Debugging

A significant portion of the work involved troubleshooting rather than running the pipeline itself.

Main issues encountered:

- Conda environment resolution stalled (~1 hour)  
- Mamba solver remained at 100% CPU for ~9 hours  
- Missing scripts in the original pipeline  
- Incorrect file format (.fastq.gz not actually gzipped)  
- Broken rule dependencies  
- Reference genome download errors (404 issues)  

This process significantly improved practical understanding of workflow debugging and environment management.

---

## Results (QUAST)

Metric | Value  
---|---  
Assembly size | 11.56 Mb  
Reference size | 12.07 Mb  
N50 | 1.91 Mb  
Contigs | 16  
NGA50 | 623 kb  

### Interpretation

- Assembly size is close to the reference (~95%)  
- Contig count indicates relatively good continuity  
- N50 reflects moderate assembly quality  

The resulting assembly is usable and consistent with expectations for this dataset.

---

## How to Run

Clone the repository:

git clone https://github.com/caganyasa/Giardia-duodenalis-Genome-Assembly.git  
cd Giardia-duodenalis-Genome-Assembly  

Create environment:

conda env create -f workflow/rules/envs/genomics.yaml  
conda activate genomics_min  

Run pipeline:

snakemake --cores 4

---

## Input Data

The pipeline expects Nanopore reads in the following structure:

data/DNA/{sample}/nanopore.fastq.gz  

Update the config.yaml file to match your local data directory.

---

## Key Takeaway

The most important lesson from this work:

A simple working pipeline is more valuable than a complex non-working one.

---

## Future Work

- Polishing (Racon / Medaka)  
- Variant analysis  
- Functional annotation  
- Further modularization of the pipeline  

---

## Notes

This project uses and adapts components from the GenoDiplo pipeline:  
https://github.com/zeyak/GenoDiplo

---

## Author

Cagan Yasa
