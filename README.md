# microbiome-rmarkdown-analysis
# U.Vural

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
