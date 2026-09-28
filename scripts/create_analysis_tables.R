suppressPackageStartupMessages({
  library(phyloseq)
  library(vegan)
  library(dplyr)
  library(tibble)
})

set.seed(snakemake@params[["seed"]])

ps <- readRDS(snakemake@input[["cleaned_data"]])

group_variable <- snakemake@params[["group_variable"]]

metadata <- as.data.frame(sample_data(ps))

if (!group_variable %in% colnames(metadata)) {
  stop(
    "Grouping variable '", group_variable,
    "' was not found in the sample metadata."
  )
}

rarefaction_depth <- min(sample_sums(ps))

if (rarefaction_depth <= 0) {
  stop("The minimum sequencing depth must be greater than zero.")
}

ps_rarefied <- rarefy_even_depth(
  ps,
  sample.size = rarefaction_depth,
  rngseed = snakemake@params[["seed"]],
  replace = FALSE,
  verbose = FALSE
)

alpha_diversity <- estimate_richness(
  ps_rarefied,
  measures = c("Observed", "Shannon", "Simpson")
) |>
  rownames_to_column("SampleID") |>
  left_join(
    metadata |>
      rownames_to_column("SampleID"),
    by = "SampleID"
  )

write.csv(
  alpha_diversity,
  snakemake@output[["alpha_diversity"]],
  row.names = FALSE
)

ps_relative <- transform_sample_counts(
  ps,
  function(x) x / sum(x)
)

bray_distance <- phyloseq::distance(ps_relative, method = "bray")

pcoa <- ordinate(
  ps_relative,
  method = "PCoA",
  distance = bray_distance
)

pcoa_coordinates <- as.data.frame(pcoa$vectors[, 1:2]) |>
  rownames_to_column("SampleID") |>
  setNames(c("SampleID", "PCoA1", "PCoA2")) |>
  left_join(
    metadata |>
      rownames_to_column("SampleID"),
    by = "SampleID"
  )

write.csv(
  pcoa_coordinates,
  snakemake@output[["pcoa_coordinates"]],
  row.names = FALSE
)
