suppressPackageStartupMessages({
  library(phyloseq)
})

set.seed(snakemake@params[["seed"]])

data("GlobalPatterns", package = "phyloseq")
ps <- GlobalPatterns

group_variable <- snakemake@params[["group_variable"]]

if (!group_variable %in% colnames(sample_data(ps))) {
  stop(
    "Grouping variable '", group_variable,
    "' was not found in the sample metadata."
  )
}

if (nsamples(ps) == 0) {
  stop("The dataset contains no samples.")
}

if (ntaxa(ps) == 0) {
  stop("The dataset contains no taxa.")
}

ps_clean <- prune_taxa(taxa_sums(ps) > 0, ps)

if (ntaxa(ps_clean) == 0) {
  stop("No taxa remain after removing zero-sum taxa.")
}

saveRDS(ps_clean, snakemake@output[["cleaned_data"]])
