# A Step-by-Step Introduction to Structural Equation Modeling with lavaan in R

A Quarto-generated tutorial website covering structural equation modelling in R using **lavaan**, developed for the **Statistical Skills** module of the **MSc in Organisational Psychology** at the **University of East Anglia**.

## Citation

Michaelides, G. (2026). *A step-by-step introduction to structural equation modeling with lavaan in R*. University of East Anglia. https://michaelides.github.io/lavaan-tutorial/

## Live site

**https://michaelides.github.io/lavaan-tutorial/**

## Audience

MSc students in organisational psychology who are new to R, RStudio, and lavaan. The tutorials assume no prior R experience and walk the student through installing R, importing data, running simple inferential statistics (t-tests, ANOVA, regression), and then through the core lavaan toolkit: confirmatory factor analysis, path analysis, structural equation modelling, and mediation, with advanced coverage of multilevel models, growth curves, moderation, and measurement invariance.

## Author and attribution

This lavaan tutorial series is a port of teaching materials originally developed by **Kevin Daniels** (University of East Anglia) for his MSc Organisational Psychology Statistical Skills module, which used Mplus. The R/lavaan adaptation is by **George Michaelides** (University of East Anglia). The original Mplus materials remain with their author.

## Repository structure

```
lavaan-tutorial/
├── _quarto.yml          Quarto site configuration
├── index.qmd            Landing page
├── tutorials/           17 tutorial .qmd files in 5 sidebar groups
├── data/                Teaching dataset (PS data) + data note
├── data-raw/            One-off scripts to build the .csv mirror and growth sim
├── assets/              Site CSS
├── images/              RStudio screenshots (Posit CC-BY) and figures
├── glossary.qmd         Alphabetical glossary
├── notation.qmd         Greek-symbol notation key
├── cheatsheet.qmd       lavaan syntax cheat sheet
├── references.bib       Single BibTeX file for all tutorials
├── apa-7th-edition.csl  APA 7th citation style
├── renv.lock            Pinned R package versions for reproducibility
└── docs/                Rendered HTML output served by GitHub Pages
```

## Setup

Install R from <https://cran.r-project.org/> and Quarto from <https://quarto.org/>. Then, in the R console:

```r
install.packages(c("haven", "lavaan", "ggplot2", "psych",
                   "tidySEM", "DiagrammeR", "readxl", "texreg"))
```

To reproduce the pinned package versions tracked in `renv.lock`, run `install.packages("renv"); renv::restore()` instead. Preview the site with `quarto preview`, or render the full site into `docs/` with `quarto render`.

## Building the data files

The teaching dataset ships as both an SPSS file and a CSV mirror. The CSV is regenerated from the SPSS file via a one-off script:

```r
source("data-raw/build-csv-mirror.R")
```

The simulated longitudinal dataset used in Tutorial 15 (Growth curve models) is regenerated via:

```r
source("data-raw/simulate-growth.R")
```

## Publishing

The site publishes to GitHub Pages automatically via a GitHub Actions workflow (`.github/workflows/render-site.yml`). On every push to `main` that touches tutorial content, the workflow renders the site into `docs/` and commits the rendered output back to `main`. GitHub Pages serves the `docs/` folder from the `main` branch.

## License

- **Tutorial content** (text, diagrams, exercises): [CC-BY 4.0](LICENSE).
- **Code blocks** (R/lavaan snippets): [MIT](LICENSE-CODE).

## Contact

George Michaelides — g.michaelides@uea.ac.uk

Norwich Business School, University of East Anglia, Norwich, UK.
