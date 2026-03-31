# TP1 individuel sous le thème : Plan de sondage et jointures avec la base EHCVM 2021/2022
# Par Nkwa Tsamo Leslye Patricia

# vidons l'environnement de travail
rm(list = ls())

# chargeons les packages nécessaires
pkgs <- c("tidyverse", "haven", "labelled", "here", "flextable",
          "officer", "srvyr", "survey", "knitr", "rmarkdown")

manquants <- pkgs[!pkgs %in% installed.packages()[, 1]]
if (length(manquants) > 0) {
  cat("Packages manquants :", paste(manquants, collapse = ", "), "\n")
  cat("Lancez renv::restore() puis relancez main.R\n")
  stop("Environnement non initialisé.")
}

invisible(lapply(pkgs, library, character.only = TRUE))
cat("Packages chargés :", length(pkgs), "\n")

# pour assurer la reproductibilité des résultats
set.seed(2070)

# Exécutons les scripts 
source(here("scripts", "preparation.R"), encoding = "UTF-8")
source(here("scripts", "analyses.R"),  encoding = "UTF-8")

# Générons automatiquement le rapport Word à partir du Rmd
rmarkdown::render(
  here("docs", "rapport.Rmd"),
  output_format = "word_document",
  output_file   = here("docs", "rapport.docx")
)
cat("Rapport Word généré : docs/rapport.docx\n")