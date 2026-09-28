# scripts/install_dependencies.R
#
# Install R package dependencies for this project.
# Run once from the RStudio Console:
# source("scripts/install_dependencies.R")
#
# TinyTeX is required only to render the R Markdown report to PDF.
# It is not required for HTML rendering.

check_and_install_cran <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

cran_packages <- c(
  "tidyverse",
  "vegan",
  "ape",
  "rmarkdown",
  "knitr",
  "here",
  "janitor",
  "tinytex"
)

invisible(lapply(cran_packages, check_and_install_cran))

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

bioconductor_packages <- c(
  "phyloseq",
  "microbiome"
)

for (pkg in bioconductor_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    BiocManager::install(pkg, ask = FALSE, update = FALSE)
  }
}

if (!tinytex::is_tinytex()) {
  tinytex::install_tinytex()
}

message("Dependencies are installed.")