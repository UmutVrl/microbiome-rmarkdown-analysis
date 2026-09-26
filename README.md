# 16S rRNA Microbiome Analysis Pipeline

A reproducible workflow for processing and analysing 16S rRNA microbiome data using **R**, **Snakemake**, and **R Markdown**.

The pipeline validates feature-table, taxonomy, and sample-metadata inputs; prepares clean analysis tables; calculates alpha diversity; performs beta-diversity ordination using PCoA; and renders an HTML analysis report.

This project conducts an exploratory downstream analysis of processed 16S rRNA amplicon sequencing data from the GlobalPatterns dataset. It evaluates sequencing depth, alpha diversity, beta diversity, taxonomic composition, and differences in microbial community structure across sample types using R, phyloseq, vegan, and R Markdown

## Features

- Input validation for metadata, feature table, and taxonomy assignments
- Sample and feature-table cleaning
- Alpha-diversity calculation
- Principal Coordinates Analysis (PCoA) for beta diversity
- Reproducible workflow orchestration with Snakemake
- Automatically generated HTML report

## Workflow overview

``` text
data/*.tsv
   │
   ▼
scripts/validate_data.R
   │
   ▼
results/cleaned_data.rds
   │
   ├── scripts/create_analysis_tables.R
   │      ├── results/alpha_diversity.csv
   │      └── results/pcoa_coordinates.csv
   │
   ▼
reports/microbiome_16s_analysis.Rmd
   │
   ▼
results/microbiome_16s_analysis.html
```

## Repository structure

``` text
microbiome-16s-rmarkdown-analysis/
├── README.md
├── config/
│   └── config.yaml
├── data/
│   ├── metadata.tsv
│   ├── feature_table.tsv
│   └── taxonomy.tsv
├── workflow/
│   └── Snakefile
├── scripts/
│   ├── validate_data.R
│   └── create_analysis_tables.R
├── reports/
│   └── microbiome_16s_analysis.Rmd
└── results/
    ├── cleaned_data.rds
    ├── alpha_diversity.csv
    ├── pcoa_coordinates.csv
    └── microbiome_16s_analysis.html
```

## Input data

Place the input files in the `data/` directory.

| File | Description | Expected structure |
|------------------------|------------------------|------------------------|
| `metadata.tsv` | Sample-level metadata | Rows are samples; includes a unique sample identifier column and experimental variables such as group, treatment, timepoint, or site |
| `feature_table.tsv` | ASV/OTU abundance table | Rows are microbial features; columns are samples; values are non-negative read counts |
| `taxonomy.tsv` | Taxonomic annotations | Rows correspond to feature identifiers in `feature_table.tsv`; includes taxonomic ranks such as Kingdom, Phylum, Class, Order, Family, Genus, and Species |

### Important requirements

- Sample IDs in `metadata.tsv` must match the sample-column names in `feature_table.tsv`.
- Feature IDs in `taxonomy.tsv` must match the feature-row names in `feature_table.tsv`.
- Use tab-separated files (`.tsv`).
- Keep raw counts in the feature table. Do not provide relative-abundance values unless the scripts are explicitly configured for them.
- Missing values should be represented consistently, for example as `NA`.

## Configuration

Edit `config/config.yaml` to define analysis settings, such as:

- Input and output paths
- Sample-ID column name
- Metadata variables used for grouping or visualisation
- Filtering thresholds
- Diversity metrics
- Ordination settings

Example:

``` yaml
input:
  metadata: "data/metadata.tsv"
  feature_table: "data/feature_table.tsv"
  taxonomy: "data/taxonomy.tsv"

output_dir: "results"

analysis:
  sample_id_column: "SampleID"
  grouping_variable: "Group"
  min_library_size: 1000
```

Adjust the field names and thresholds to match your dataset and research question.

## Installation

### Requirements

- R (recommended: version 4.2 or later)
- Snakemake (recommended: version 7 or later)
- Pandoc, required for rendering the R Markdown HTML report

The R scripts may require packages such as:

``` r
install.packages(c(
  "tidyverse",
  "vegan",
  "rmarkdown",
  "knitr",
  "yaml"
))
```

If the project uses Bioconductor packages such as `phyloseq`, install them with:

``` r
install.packages("BiocManager")
BiocManager::install(c("phyloseq", "microbiome"))
```

> Check the `scripts/` and `reports/` files for the exact package requirements used in this repository.

### Optional: create a Conda environment

``` bash
conda create -n microbiome16s -c conda-forge -c bioconda \
  snakemake r-base r-tidyverse r-vegan r-rmarkdown pandoc
conda activate microbiome16s
```

## Run the analysis

From the repository root directory, run:

``` bash
snakemake --snakefile workflow/Snakefile --cores 1
```

For parallel execution, replace `1` with the number of CPU cores you want to use:

``` bash
snakemake --snakefile workflow/Snakefile --cores 4
```

To preview the planned workflow without running it:

``` bash
snakemake --snakefile workflow/Snakefile --cores 1 --dry-run
```

To rerun all output files:

``` bash
snakemake --snakefile workflow/Snakefile --cores 4 --forceall
```

## Outputs

All generated files are saved in `results/`.

| Output file | Description |
|------------------------------------|------------------------------------|
| `cleaned_data.rds` | Cleaned and validated microbiome data object used by downstream analyses |
| `alpha_diversity.csv` | Per-sample alpha-diversity metrics, such as observed richness and Shannon diversity |
| `pcoa_coordinates.csv` | Sample coordinates from Principal Coordinates Analysis (PCoA) |
| `microbiome_16s_analysis.html` | Rendered analysis report containing methods, quality checks, tables, figures, and interpretation |

Open the report locally in a web browser:

``` bash
open results/microbiome_16s_analysis.html
```

On Linux, you can use:

``` bash
xdg-open results/microbiome_16s_analysis.html
```

## Reproducibility

This project separates:

- **Raw input data** in `data/`
- **Analysis configuration** in `config/config.yaml`
- **Workflow logic** in `workflow/Snakefile`
- **Data-processing scripts** in `scripts/`
- **Reporting code** in `reports/`
- **Generated results** in `results/`

For a fully reproducible analysis, record your software versions:

``` bash
snakemake --version
R --version
pandoc --version
```

You can also save the installed R package versions:

``` r
sessionInfo()
```

## Notes on interpretation

Alpha diversity describes diversity within individual samples, whereas PCoA visualises differences in community composition between samples. PCoA plots are exploratory: apparent separation between groups should be evaluated with an appropriate statistical test, such as PERMANOVA, and interpreted alongside study design, sample size, sequencing depth, and potential confounders.

## License

Add a license appropriate for your project, for example:

``` text
MIT License
```

## Author

Umutcan Vural

For questions, suggestions, or collaboration, please open an issue in this repository.


#Introduction to Microbiome analysis

Source:https://training.galaxyproject.org/training-material/topics/microbiome/tutorials/introduction/slides.html#p1

#Microbiome Analysis
Microbiome analysis is the examination of the collection of microorganisms (microbes) in a particular environment, such as the human body, soil, water, or any other habitat.
This analysis aims to understand the composition, diversity, and functions of these microbial communities.

#Overview
Studying the microbiome is essential because it plays a crucial role in human health by influencing digestion, immunity, and disease susceptibility.
It also helps in understanding and improving agricultural productivity and environmental sustainability through insights into soil and plant microbiomes.
Additionally, microbiome research can lead to the development of new medical therapies, diagnostics, and biotechnological applications.
DNA-based microbiome analysis is mainly based on two techniques: Amplicon sequencing and Shotgun sequencing.
Microbiome analysis required sophisticated analysis pipelines for the processing and the interpretation of the sequence data.

#Why study the microbiome?
The term "second genome" refers to the vast collection of microbial genes present in and on the human body, which outnumber human genes by about 100 to 1.
This microbial genetic material plays a crucial role in various physiological processes, such as digestion, immunity, and even mental health, making it an integral part of our overall genetic makeup and health.

In environmental studies, the microbiome refers to the diverse communities of microorganisms living in various environments such as soil, water, and plants.
These microbial communities are critical for ecosystem functions like nutrient cycling, soil fertility, pollutant degradation, and plant health, thus playing a vital role in maintaining environmental balance and sustainability.

#Types of microbiome analysis
Meta-omics refers to a suite of high-throughput techniques used to study various aspects of microbial communities in an integrated way, providing a comprehensive view of their functions, structures, and interactions.
Metagenomics involves sequencing the entire genetic material from a microbial community, offering insights into the diversity, composition, and potential functions of the microorganisms.
Metatranscriptomics examines RNA transcripts to assess gene expression and microbial responses to environmental changes.
Metametabolomics analyzes the small molecules produced by microbial metabolism to understand their metabolic activities and interactions.
Metaproteomics focuses on studying microbial proteins to uncover their roles, expression levels, and interactions.
Amplicon sequencing, though more targeted, involves sequencing specific genetic regions to profile microbial diversity and abundance.

#Shotgun vs Amplicon
Shotgun sequencing analyzes the entire genetic material in a sample, providing comprehensive and detailed information about microbial community structure and function, but it is complex and costly.
Amplicon sequencing targets specific regions of microbial DNA, such as the 16S rRNA gene, offering a cost-effective and simpler method for profiling microbial communities, though it lacks detailed functional insights and is subject to amplification bias.
Shotgun sequencing is ideal for detailed metabolic and functional studies, while amplicon sequencing is suitable for assessing microbial composition and diversity.

#Amplicon
Amplicon sequencing is a targeted approach that focuses on sequencing specific genetic regions to identify and analyze microbial communities.
For bacteria, the 16S rRNA gene is commonly targeted, while the 18S rRNA gene is used for eukaryotes, and the ITS region is targeted for fungi.
This method allows for efficient and cost-effective profiling of microbial composition and diversity by amplifying and sequencing these specific genetic markers.

The 16S rRNA gene used in amplicon sequencing for bacteria consists of both conserved and variable regions.
The conserved regions are highly similar across different bacterial species, providing anchor points for primers used in sequencing.
The variable (V) regions, on the other hand, are more diverse and unique to different species, allowing for the differentiation and identification of bacteria within a sample.
Sequencing these V regions enables researchers to profile the bacterial community and understand its composition and diversity

Amplicon sequencing is cost-effective and simpler than other methods, making it accessible for routine studies and straightforward to analyze due to its focus on specific genetic regions.
However, it has limitations, such as only providing information about the targeted regions, which may miss some microbial diversity and functional insights.
Additionally, the method can introduce amplification biases and may not differentiate closely related species or strains effective

#Shotgun metagenomics
Shotgun metagenomics is a comprehensive approach to analyzing microbial communities by sequencing all the genetic material present in a sample, rather than focusing on specific regions.
This technique involves fragmenting the entire DNA from a sample, sequencing these fragments, and then using computational tools to assemble and analyze the data.
By capturing the complete genetic makeup of all microorganisms, including bacteria, archaea, viruses, and eukaryotes, shotgun metagenomics provides detailed insights into the diversity, composition, and functional potential of microbial communities.
This method allows for a broad and deep understanding of microbial interactions and functions, though it is often more complex and costly compared to targeted sequencing approaches.
Additionally, shotgun metagenomics can be affected by host contamination, which may complicate the interpretation of microbial data.

In end-to-end metagenomic workflows, every step—from sample collection to data analysis—can significantly impact the final results.
Sample collection methds can introduce biases or contaminants, affecting the accuracy of microbial representation.
During DNA extraction, variations in protocols or efficiencies can alter the quantity and quality of genetic material obtained.
Sequencing technologies and their associated errors can introduce noise or gaps in the data.
Data processing, including assembly and annotation, relies on computational tools and databases that may -influence the interpretation of microbial diversity and functions.
Finally, the integration and analysis of results can be affected by the algorithms used and the quality of the reference databases.
Each of these steps must be carefully controlled and standardized to ensure reliable and reproducible outcomes in metagenomic studies

#Bioinformatics
In metagenomics, "drowning in NGS data" refers to the overwhelming volume of data generated by next-generation sequencing technologies.
This issue arises because NGS can produce vast amounts of sequence reads from complex microbial communities in a single experiment, creating challenges in data management, processing, and interpretation.
Managing and organizing this massive data set requires substantial computational resources, while analyzing it involves quality control, read assembly, taxonomic classification, and functional annotation, all of which add complexity and computational demands.
Extracting meaningful biological insights from such extensive data requires advanced bioinformatics expertise to navigate potential noise and errors and to ensure that findings are robust and reproducible.

#Analysis pipelines
Amplicon sequencing focuses on specific genetic regions, such as the 16S rRNA gene for bacteria, offering a cost-effective and simpler pipeline that provides insights into microbial community composition but may miss broader diversity and functional details.
In contrast, shotgun metagenomics sequences all genetic material, delivering a comprehensive view of microbial diversity and functional potential, though it requires more complex and expensive analysis.
Operational Taxonomic Units (OTUs) group sequences based on similarity, which can obscure finer taxonomic distinctions and is often used in amplicon pipelines.
Amplicon Sequence Variants (ASVs) represent exact sequences without grouping, offering higher resolution and more accurate taxonomic identification, 
and are increasingly used in modern amplicon pipelines for greater precision in microbial profiling.

#Pre-processing
Preprocessing in metagenomics involves a series of steps to prepare raw sequencing data for analysis, including quality control, trimming of low-quality sequences, removal of contaminants, and filtering out redundant or erroneous data.
This stage is crucial for ensuring that the data used for downstream analysis is accurate and reliable.
The trade-off between quality and amount of information retained is a key consideration in preprocessing.
On one hand, stringent quality control measures improve the accuracy of the data by removing errors and contaminants, but this can also lead to the loss of some useful information, particularly from low-abundance or poorly sequenced organisms.
On the other hand, retaining more data might include lower-quality sequences or noise, which can complicate data analysis and interpretation.
Balancing these factors involves optimizing preprocessing steps to retain the most informative and accurate data while minimizing errors and maintaining sufficient coverage for meaningful analysis.

#OTU clustering/denoising
OTU clustering groups similar sequence reads into Operational Taxonomic Units based on a predefined similarity threshold, which can simplify the data but may mask finer taxonomic differences and reduce resolution by lumping closely related species together.
In contrast, ASV denoising involves identifying and retaining exact sequence variants without grouping, providing higher resolution and more precise taxonomic identification by distinguishing unique sequences and reducing errors, though it requires more sophisticated algorithms and computational resources.

#Chimera removal
Chimera removal is a crucial step in microbiome data processing that involves identifying and eliminating chimeric sequences—artificial DNA sequences that arise from the incorrect joining of two or more distinct sequences during PCR amplification.
These chimeras can distort the representation of microbial communities by introducing erroneous sequences that do not reflect actual biological entities.
The removal of chimeric sequences is essential for ensuring accurate and reliable results in downstream analyses, such as taxonomic classification and diversity assessment.

#Search marker database and taxonomy assignment
In microbiome studies, searching a marker database involves comparing sequencing data to a reference database to identify microbial sequences.
For example, in amplicon sequencing, sequences might be compared to the SILVA database, which contains rRNA gene sequences, to classify microorganisms based on known genetic markers.
In shotgun metagenomics, the MetaPhlAn database can be used, which contains unique marker genes for various microorganisms, enabling precise taxonomy assignment and detailed profiling of the microbial community.

#Search functional database
For functional analysis, researchers can use databases like UniRef50 and UniRef90, which cluster sequences into representative sets to help identify proteins and their functions.
MetaCyc Reactions provides detailed information on metabolic pathways and enzymatic reactions, allowing the identification of metabolic capabilities within the microbiome.
EggNOG offers orthologous group annotations, helping to predict gene functions and evolutionary relationships.
These functional databases provide deeper insights into the biological roles and potential activities of the microbial community, complementing the taxonomic data.

#Results:OTU table
The results of microbiome studies are typically compiled into a comprehensive summary such as an OTU table or a similar data structures.
In this table, each row represents an OTU, while each column represents a different sample analyzed.
The cells within the table contain values indicating the abundance of each OTU in each sample, often presented as counts or relative frequencies.
This format provides a detailed overview of the microbial community composition across multiple samples, allowing researchers to compare diversity and abundance patterns, and perform statistical analyses to assess differences between sample groups, microbial diversity, and correlations with environmental or health-related variables.
Comparable tables for other modality of microbiome studies are taxonomy tables, gene tables and pathway tables.

#Results:Visualisation
Visualizations of microbiome data are crucial for several reasons.
They transform complex, high-dimensional data into interpretable and accessible formats, allowing researchers to quickly grasp the composition and diversity of microbial communities.
Krona is a visualization tool used to explore microbiome data from an OTU table interactively.
First, the OTU table, with taxonomic classifications and abundance data, is formatted into a compatible file for Krona.
The software then processes this file to create an interactive, multi-layered pie chart where each layer represents different taxonomic levels, such as phylum, class, order, family, genus, and species.
Users can click on segments to drill down into lower taxonomic levels, with the segment sizes indicating the relative abundance of each taxon.
This allows for intuitive and interactive exploration of the microbial community structure, making it easy to identify patterns and differences across samples.

Phinch is another powerful tool for visualizing microbiome data, offering interactive and customizable charts that help in exploring complex datasets.

#Differential analyses
Differential microbiome analysis using tools like MaAsLin2 involves comparing microbial community profiles between different groups or conditions to identify significant differences in microbial abundance or diversity.
MaAsLin2 uses linear models to handle complex, high-dimensional data and adjust for potential confounders, providing robust statistical insights into which microbes are differentially abundant.
This analysis helps in understanding how microbial shifts correlate with various factors, such as disease states or environmental changes, thereby uncovering potential biomarkers and functional implications.

#Diversity
Alpha diversity measures the diversity within a single sample, reflecting the number of species and their relative abundances.
Beta diversity compares microbial communities between samples, highlighting differences in species composition and abundance.
Together, these metrics provide insights into both the internal diversity of communities and how they vary across different conditions.

#Assembly
Microbiome assembly involves reconstructing the complete genomes of microorganisms from sequencing data to understand their functional potential and diversity.

#Binning
After the initial assembly of contigs from sequencing data, binning helps to differentiate and categorize these contigs based on their genetic similarity, coverage, and other characteristics, effectively reconstructing individual microbial genomes from the mixed sample.


| Step                        | Do it for GlobalPatterns now? | Why                                                                                  |
| --------------------------- | ----------------------------- | ------------------------------------------------------------------------------------ |
| Import raw reads            | No                            | The source reads are not your project input                                          |
| Preprocessing / read QC     | No                            | Read-level preprocessing has already occurred                                        |
| Clustering                  | No                            | The dataset already contains processed OTU/features                                  |
| Denoising                   | No                            | This is a raw-read step, normally DADA2/Deblur                                       |
| Chimera removal             | No                            | Normally part of raw-read denoising/preprocessing                                    |
| Taxonomy assignment         | No                            | Taxonomy is already supplied in tax_table(ps)                                        |
| Search functional databases | No                            | 16S profiles are primarily taxonomic; they do not directly measure functional genes  |
| Validate table / metadata   | Yes                           | You must check what the processed data contain and whether samples/labels are usable |
| Inspect sequencing depth    | Yes                           | You need to understand library-size variation                                        |
| Filter samples/taxa         | Yes, carefully                | This is analysis-specific filtering, not raw-read cleaning                           |
| Alpha diversity             | Yes                           | Core question: within-sample richness/diversity                                      |
| Beta diversity              | Yes                           | Core question: differences among communities                                         |
| PCoA / NMDS visualization   | Yes                           | Shows patterns in multivariate community differences                                 |
| PERMANOVA                   | Yes                           | Tests association between community composition and sample type                      |
| Taxonomic composition       | Yes                           | Shows taxa contributing to the observed patterns                                     |
| Reporting                   | Yes                           | R Markdown + GitHub is your project deliverable                                      |

