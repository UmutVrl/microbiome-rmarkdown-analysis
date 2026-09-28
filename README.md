# Exploratory 16S microbiome analysis in R

A reproducible R Markdown analysis of the `GlobalPatterns` 16S rRNA microbiome dataset included with the `phyloseq` R package.

## Research question

How do microbial diversity and community composition vary across sample types in the GlobalPatterns dataset?

## Structure

microbiome-16s-rmarkdown-analysis/
├── README.md
├── .gitignore
├── microbiome-16s-rmarkdown-analysis.Rproj
├── notes.txt
├── install_dependencies.R
├── snakemake.txt
└── reports/
    ├── microbiome_16s_analysis.Rmd
    └── microbiome_16s_analysis.html

## Workflow

1. Load and inspect processed 16S microbiome data.
2. Assess sequencing depth and rarefaction curves.
3. Remove features with zero counts across all samples.
4. Calculate alpha diversity using rarefied counts.
5. Calculate Bray–Curtis beta diversity from relative-abundance profiles.
6. Visualise community structure with PCoA.
7. Test association between sample type and composition using PERMANOVA and assess multivariate dispersion.
8. Visualise phylum-level taxonomic composition.

## Main findings

- Soil samples showed the highest observed richness and Shannon diversity.
- Freshwater creek samples had high richness but lower Shannon diversity and were dominated by Cyanobacteria.
- Sample type was strongly associated with Bray–Curtis community composition, though unequal group dispersion requires cautious interpretation.
- Mock and freshwater creek samples showed relatively low within-group compositional variation.

## Data and scope

The analysis uses a processed feature table, taxonomy, metadata, and phylogenetic tree supplied by `phyloseq`. It demonstrates downstream 16S microbiome analysis; it does not reproduce upstream raw-read processing, denoising, chimera removal, or taxonomy assignment.

## Installation & Reproduction:

1. Install R and RStudio.
2. Install the required packages:

From the project root in RStudio, install the project dependencies once:

```r
source("scripts/install_dependencies.R")
```

This installs the required CRAN and Bioconductor packages. It also installs TinyTeX if it is not available, enabling optional PDF rendering.

3. Open `reports/microbiome_16s_analysis.Rmd` in RStudio.
4. To produce the report without LaTeX, knit `reports/microbiome_16s_analysis.Rmd` to HTML. TinyTeX is required only for PDF output.

## Repository contents

- `reports/microbiome_16s_analysis.Rmd`: source code and narrative report.
- `results/microbiome_16s_analysis.html`: rendered analysis report.
- `results/microbiome_16s_analysis.pdf`: rendered analysis report.

## Limitations

Results are exploratory because the dataset contains heterogeneous environments and small, unequal sample-type groups. Microbiome sequencing data are compositional, and alpha-diversity estimates may be conservative for lower-depth samples.
