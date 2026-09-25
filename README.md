# microbiome-rmarkdown-analysis
# U.Vural

# TODO
# environment.yml & renv.lock

# 16S rRNA Microbiome Analysis Pipeline

A reproducible workflow for processing and analysing 16S rRNA microbiome data using **R**, **Snakemake**, and **R Markdown**.

The pipeline validates feature-table, taxonomy, and sample-metadata inputs; prepares clean analysis tables; calculates alpha diversity; performs beta-diversity ordination using PCoA; and renders an HTML analysis report.

## Features

- Input validation for metadata, feature table, and taxonomy assignments
- Sample and feature-table cleaning
- Alpha-diversity calculation
- Principal Coordinates Analysis (PCoA) for beta diversity
- Reproducible workflow orchestration with Snakemake
- Automatically generated HTML report

## Workflow overview

```text
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

```text
=======
>>>>>>> 8d493cd82ed66cc2ba5b038a23317d2233f4fb79
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
<<<<<<< HEAD
```

## Input data

Place the input files in the `data/` directory.

| File | Description | Expected structure |
|---|---|---|
| `metadata.tsv` | Sample-level metadata | Rows are samples; includes a unique sample identifier column and experimental variables such as group, treatment, timepoint, or site |
| `feature_table.tsv` | ASV/OTU abundance table | Rows are microbial features; columns are samples; values are non-negative read counts |
| `taxonomy.tsv` | Taxonomic annotations | Rows correspond to feature identifiers in `feature_table.tsv`; includes taxonomic ranks such as Kingdom, Phylum, Class, Order, Family, Genus, and Species |

### Important requirements

- Sample IDs in `metadata.tsv` must match the sample-column names in `feature_table.tsv`.
- Feature IDs in `taxonomy.tsv` must match the feature-row names in `feature_table.tsv`.
- Use tab-separated files (`.tsv`).
- Keep raw counts in the feature table. Do not provide relative-abundance values unless the scripts are explicitly config
=======
>>>>>>> 8d493cd82ed66cc2ba5b038a23317d2233f4fb79
