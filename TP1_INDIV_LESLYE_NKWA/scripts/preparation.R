# scripts de preparation
# Chargement et exploration des bases EHCVM 2021/2022 du Sénégal

# 1. Chargement des bases
menage   <- read_dta(here("data", "ehcvm_menage_SEN2021.dta"))
individu <- read_dta(here("data", "ehcvm_individu_SEN2021.dta"))
welfare  <- read_dta(here("data", "ehcvm_welfare_SEN2021.dta"))
conso    <- read_dta(here("data", "ehcvm_conso_SEN2021.dta"))

cat(" Dimensions des bases \n")
cat(sprintf("menage   : %d lignes x %d colonnes\n", nrow(menage),   ncol(menage)))
cat(sprintf("individu : %d lignes x %d colonnes\n", nrow(individu), ncol(individu)))
cat(sprintf("welfare  : %d lignes x %d colonnes\n", nrow(welfare),  ncol(welfare)))
cat(sprintf("conso    : %d lignes x %d colonnes\n", nrow(conso),    ncol(conso)))

# 2. Vérification de l'unicité des clés
cat("\n Unicité de la clé (grappe, menage)\n")
cat("menage   :", sum(duplicated(menage[c("grappe","menage")])),   "doublons\n")
cat("individu - (grappe, menage, numind) unique :",
    sum(duplicated(individu[c("grappe","menage","numind")])), "doublons\n")
cat("welfare  :", sum(duplicated(welfare[c("grappe","menage")])),  "doublons\n")

# 3. Vérification de la couverture
n_men_ind <- individu |> distinct(grappe, menage) |> nrow()
cat(sprintf("\nMénages distincts dans individu : %d (attendu : %d)\n",
            n_men_ind, nrow(menage)))

# 4. Plan de sondage 
plan_sondage <- individu |>
  filter(!is.na(hhweight)) |>
  mutate(strate = paste(as.numeric(region), as.numeric(milieu), sep = "_")) |>
  as_survey_design(
    ids     = grappe,
    strata  = strate,
    weights = hhweight,
    nest    = TRUE
  )
cat(sprintf("\nPlan de sondage défini : %d individus pondérés\n",
            nrow(individu |> filter(!is.na(hhweight)))))
cat(sprintf("Somme des poids : %.0f (estimation population)\n",
            sum(individu$hhweight, na.rm = TRUE)))

# 5. Sauvegardons les objets pour analyses.R
saveRDS(menage,       here("data", "menage.rds"))
saveRDS(individu,     here("data", "individu.rds"))
saveRDS(welfare,      here("data", "welfare.rds"))
saveRDS(conso,        here("data", "conso.rds"))
saveRDS(plan_sondage, here("data", "plan_sondage.rds"))
cat("Bases sauvegardées\n")
