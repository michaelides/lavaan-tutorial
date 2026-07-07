#!/usr/bin/env Rscript
# -----------------------------------------------------------------------------
# scripts/scaffold-stubs.R  (one-off; not part of the build pipeline)
#
# Generates placeholder .qmd files for each tutorial and cross-cutting page,
# following the per-tutorial template agreed in Q9a (8 sections) and Q19
# (style/voice conventions). Each stub carries the title, subtitle, sidebar
# group, and the section H2 headers with a placeholder paragraph.
#
# Re-run freely — it will refuse to overwrite an existing file.
# -----------------------------------------------------------------------------

stub_header <- function(title, subtitle, group, order) {
  sprintf(
'---
title: "%s"
subtitle: "%s"
author: "George Michaelides"
institute: "School of Psychology, University of East Anglia"
date: "2026"
sidebar-group: "%s"
order: %d
---

',
    title, subtitle, group, order
  )
}

stub_body <- function(concept = TRUE) {
  body <- character()
  body <- c(body, "## Learning objectives\n\n- TODO\n\n")
  body <- c(body, "## Setup\n\n```{r}\n#| include: false\nknitr::opts_chunk$set(comment = \"##\")\n```\n\n```{r}\n#| eval: false\nlibrary(haven)\nlibrary(lavaan)\nlibrary(ggplot2)\n```\n\n")
  if (concept) {
    body <- c(body, "## Concept\n\n_TODO: narrative + DiagrammeR path diagram + MathJax equations._\n\n")
  }
  body <- c(body, "## Worked example\n\n_TODO: code chunk -> output -> interpretation paragraph._\n\n")
  body <- c(body, "::: {.callout-warning}\n## Common errors\n\n_TODO: convergence, Heywood cases, identification._\n:::\n\n")
  body <- c(body, "## Exercises\n\n::: {.callout-tip}\n## Try it\n\n_TODO: modify the above chunk to..._\n:::\n\n::: {.callout-caution collapse=\"true\"}\n## Exercise solution\n\n_TODO_\n:::\n\n")
  body <- c(body, "## Summary & next tutorial\n\n_TODO: one-paragraph bridge._\n\n")
  body <- c(body, "## Further reading\n\n_TODO: 2-5 academic papers, APA 7th via @citekey._\n\n")
  paste(body, collapse = "")
}

tutorials <- list(
  list(file = "tutorials/01-r-basics.qmd",            title = "R basics",                          subtitle = "Objects, vectors, data frames, factors, missing values",                       group = "Foundations",  order = 1,  concept = FALSE),
  list(file = "tutorials/02-rstudio.qmd",             title = "RStudio",                           subtitle = "Projects, panes, scripts vs Quarto, packages",                                  group = "Foundations",  order = 2,  concept = FALSE),
  list(file = "tutorials/03-importing-data.qmd",      title = "Importing data",                    subtitle = "SPSS, CSV, and Excel files; missing-value codes",                              group = "Foundations",  order = 3,  concept = FALSE),
  list(file = "tutorials/04-simple-inference.qmd",    title = "Simple inference: t-test, ANOVA, lm", subtitle = "t-test, one-way ANOVA, regression with lm; introducing ggplot2",            group = "Foundations",  order = 4,  concept = FALSE),
  list(file = "tutorials/05-introducing-lavaan.qmd",  title = "Introducing lavaan",                 subtitle = "Declarative model specification with =~, ~, ~~, := ",                          group = "Bridging",     order = 5,  concept = TRUE ),
  list(file = "tutorials/06-cfa-concept.qmd",         title = "CFA — concept",                      subtitle = "Latent vs observed, identification, marker variable, model fit",               group = "Core lavaan",  order = 6,  concept = TRUE ),
  list(file = "tutorials/07-cfa-practical.qmd",       title = "CFA — practical",                   subtitle = "Two-factor CFA on NA/PA; fit, parameter estimates, modification indices",     group = "Core lavaan",  order = 7,  concept = FALSE),
  list(file = "tutorials/08-parcels-second-order.qmd", title = "Parcels and second-order CFA",     subtitle = "Parcel construction and second-order factors with lavaan",                     group = "Core lavaan",  order = 8,  concept = FALSE),
  list(file = "tutorials/09-path-analysis.qmd",       title = "Path analysis with observed variables", subtitle = "Multiple regression equations, just-identified models, R squared",          group = "Core lavaan",  order = 9,  concept = FALSE),
  list(file = "tutorials/10-sem-latent.qmd",          title = "SEM with latent variables",         subtitle = "From parceled SEM to full latent-variable SEM; disattenuation",                 group = "Core lavaan",  order = 10, concept = FALSE),
  list(file = "tutorials/11-mediation-concept.qmd",   title = "Mediation — concept",              subtitle = "Indirect, direct, total effects; multiple mediators; why we bootstrap",        group = "Core lavaan",  order = 11, concept = TRUE ),
  list(file = "tutorials/12-mediation-practical.qmd", title = "Mediation — practical",             subtitle = "Path mediation then latent SEM mediation with bootstrap BCAs",                  group = "Core lavaan",  order = 12, concept = FALSE),
  list(file = "tutorials/13-reporting.qmd",           title = "Reporting lavaan results",          subtitle = "APA write-ups, exporting tables with texreg, exporting path diagrams",        group = "Capstone",     order = 13, concept = FALSE),
  list(file = "tutorials/14-multilevel.qmd",          title = "Multilevel models",                 subtitle = "lme4 for MLM regression; lavaan for two-level SEM",                            group = "Advanced",     order = 14, concept = FALSE),
  list(file = "tutorials/15-growth.qmd",               title = "Growth curve models",              subtitle = "Latent growth in lavaan and growth in lme4; simulated longitudinal data",     group = "Advanced",     order = 15, concept = FALSE),
  list(file = "tutorials/16-moderation.qmd",           title = "Moderation",                        subtitle = "Moderated regression with lm; multigroup SEM moderation; latent interaction (advanced)", group = "Advanced",     order = 16, concept = FALSE),
  list(file = "tutorials/17-measurement-invariance.qmd", title = "Measurement invariance",          subtitle = "Multigroup CFA: configural, metric, scalar, and strict invariance; partial invariance; latent mean comparison", group = "Advanced", order = 17, concept = TRUE )
)

cross_cutting <- list(
  list(file = "glossary.qmd",     title = "Glossary",        subtitle = "Key terms used across the tutorials",        concept = FALSE, group = "Reference", order = NA),
  list(file = "notation.qmd",    title = "Notation",         subtitle = "Greek symbols used in SEM and their lavaan output homes", concept = FALSE, group = "Reference", order = NA),
  list(file = "cheatsheet.qmd",  title = "lavaan syntax cheat sheet", subtitle = "Quick reference for =~, ~, ~~, := and friends",   concept = FALSE, group = "Reference", order = NA),
  list(file = "data/data-note.qmd", title = "PS dataset — variable definitions", subtitle = "Variable definitions, response scales, source citations", concept = FALSE, group = "Reference", order = NA)
)

write_unique <- function(path, content) {
  if (file.exists(path)) {
    message("Skipping existing file: ", path)
    return(invisible(FALSE))
  }
  dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
  writeLines(content, path, useBytes = TRUE)
  message("Wrote: ", path)
  invisible(TRUE)
}

for (t in tutorials) {
  body <- if (t$concept) stub_body(TRUE) else stub_body(FALSE)
  write_unique(t$file, paste0(stub_header(t$title, t$subtitle, t$group, t$order), body))
}

# Cross-cutting pages get a minimal body (the 8-section template doesn't apply)
for (cc in cross_cutting) {
  header <- sprintf(
'---
title: "%s"
subtitle: "%s"
author: "George Michaelides"
institute: "School of Psychology, University of East Anglia"
date: "2026"
---

## %s

_TODO: content._

', cc$title, cc$subtitle, cc$title)
  write_unique(cc$file, header)
}

message("\nScaffolding complete.")
