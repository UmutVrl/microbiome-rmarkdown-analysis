suppressPackageStartupMessages({
  library(phyloseq)
  library(dplyr)
  library(tibble)
  library(readr)
})

set.seed(snakemake@params[["seed"]])

group_variable <- snakemake@params[["group_variable"]]

# ---- Read validated/cleaned data from the previous rule ----
ps_clean <- readRDS(snakemake@input[["cleaned_data"]])

# ---- Depth table (needed for the alpha-diversity join, as in the Rmd) ----
depth_df <- tibble(
  SampleID   = sample_names(ps_clean),
  LibSize    = sample_sums(ps_clean),
  SampleType = sample_data(ps_clean)[[group_variable]]
)

# =========================================================
# Alpha diversity (mirrors the Rmd's "Alpha diversity" section)
# =========================================================

# Rarefy to the minimum observed depth, same approach as the Rmd
GlobalPatterns_rare <- rarefy_even_depth(
  ps_clean,
  sample.size = min(sample_sums(ps_clean)),
  rngseed     = snakemake@params[["seed"]],
  replace     = FALSE,
  verbose     = FALSE
)

alpha_diversity <- estimate_richness(
  GlobalPatterns_rare,
  measures = c("Observed", "Shannon", "Simpson")
) |>
  tibble::rownames_to_column("SampleID") |>
  left_join(
    depth_df |>
      select(SampleID, SampleType, LibSize),
    by = "SampleID"
  )

readr::write_csv(alpha_diversity, snakemake@output[["alpha_diversity"]])

# =========================================================
# Beta diversity / PCoA (mirrors the Rmd's "Beta diversity / PCoA" section)
# =========================================================

# Relative abundance, same approach as the Rmd (NOT rarefied a second time)
GlobalPatterns_relabund <- transform_sample_counts(
  ps_clean,
  function(x) x / sum(x)
)

bray_dist <- phyloseq::distance(GlobalPatterns_relabund, method = "bray")

pcoa_ord <- ordinate(GlobalPatterns_relabund, method = "PCoA", distance = bray_dist)

pcoa_eig <- pcoa_ord$values$Relative_eig
var_pc1  <- round(pcoa_eig[1] * 100, 1)
var_pc2  <- round(pcoa_eig[2] * 100, 1)

pcoa_coordinates <- as.data.frame(pcoa_ord$vectors[, 1:2]) |>
  rownames_to_column("SampleID") |>
  rename(PCoA1 = Axis.1, PCoA2 = Axis.2) |>
  left_join(
    depth_df |> select(SampleID, SampleType),
    by = "SampleID"
  ) |>
  mutate(
    VarExplainedPCoA1 = var_pc1,  # repeated per row so the report can read
    VarExplainedPCoA2 = var_pc2   # axis-label percentages without a 2nd file
  )

readr::write_csv(pcoa_coordinates, snakemake@output[["pcoa_coordinates"]])
