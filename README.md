# Microbiome Heritability (h²) Explorer

An interactive Shiny application for exploring heritability (h²) estimates of gut microbial taxa, compiled from 9 published GWAS and family-based studies. The app allows users to compare h² estimates - with 95% confidence intervals - across independent cohorts and estimation methods, at six taxonomic levels from phylum to species.

**Live app:** https://uzu1p0-alec-mckinlay.shinyapps.io/microbiomeh2_shiny/

---

## Overview

Estimates of gut microbiome heritability vary substantially across studies, depending on the cohort, taxonomic resolution, and statistical method used. This app aggregates estimates from SNP-based (chip and LDSC), twin-based (ACE decomposition), and pedigree-based methods, enabling direct visual comparison of which microbial taxa show consistent heritable signal across independent populations.

---

## Studies Included

| Study | Year | Method | N estimates | Reference |
|---|---|---|---|---|
| Kurilshikov et al. (MiBioGen) | 2021 | h²\_SNP (LDSC) | 211 | [Nature Genetics](https://doi.org/10.1038/s41588-020-00763-1) |
| Kurilshikov et al. (MiBioGen — twins arm) | 2021 | h²\_Twin (ACE) | 209 | [Nature Genetics](https://doi.org/10.1038/s41588-020-00763-1) |
| Rühlemann et al. | 2021 | h²\_SNP (LDSC) | 57 | [Nature Genetics](https://doi.org/10.1038/s41588-020-00747-1) |
| Hughes et al. | 2020 | h²\_SNP | 92 | [Nature Microbiology](https://doi.org/10.1038/s41564-020-0743-8) |
| Xu et al. | 2020 | h²\_SNP | 203 | [Microbiome](https://doi.org/10.1186/s40168-020-00923-9) |
| Ishida et al. | 2020 | h²\_SNP | 21 | [Communications Biology](https://doi.org/10.1038/s42003-020-01416-z) |
| Boulund et al. (HELIUS) | 2022 | h²\_SNP | 401 | [Cell Host & Microbe](https://doi.org/10.1016/j.chom.2022.08.013) |
| Davenport et al. | 2015 | h²\_SNP | 105 | [PLOS ONE](https://doi.org/10.1371/journal.pone.0140301) |
| Goodrich et al. | 2016 | h²\_Twin (ACE) | 945 | [Cell Host & Microbe](https://doi.org/10.1016/j.chom.2016.04.017) |
| Turpin et al. | 2016 | h²\_Pedigree | 193 | [Nature Genetics](https://doi.org/10.1038/ng.3693) |
| Lopera-Maya et al. (Dutch Microbiome Project) | 2022 | h²\_Pedigree | 239 | [Nature Genetics](https://doi.org/10.1038/s41588-021-00992-y) |

---

## App Features

- **Taxonomy selector** — choose from Phylum, Class, Order, Family, Genus, or Species
- **Trait selector** — dynamically populated based on selected taxonomic level; harmonised trait names allow cross-study comparison
- **Forest plot** — h² point estimates with 95% CIs, ordered by h² magnitude, colour-coded by estimation method
- **Raw data table** — table of filtered estimates including p-values

---

## Running Locally

```r
# Install dependencies
install.packages(c("shiny", "ggplot2", "dplyr", "ggthemes",
                   "viridis", "plotly", "DT", "rlang", "scales"))

# Run the app
shiny::runApp("app.R")
```

Requires R ≥ 4.0 and the `dataforplots.RData` file in the working directory.
