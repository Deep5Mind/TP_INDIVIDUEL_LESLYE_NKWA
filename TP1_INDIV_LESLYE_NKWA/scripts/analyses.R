# scripts des analyses
# Jointures entre les bases EHCVM 2021/2022

# Couleurs
col_turquoise <- "#248a8a"
col_clair     <- "#c7f5f5"
col_header    <- "#1A5C5C"
blanc         <- "#f7faff"
gris_bord     <- "#969696"

menage   <- readRDS(here("data", "menage.rds"))
individu <- readRDS(here("data", "individu.rds"))
welfare  <- readRDS(here("data", "welfare.rds"))
conso    <- readRDS(here("data", "conso.rds"))

# Clé de jointure composite
cle <- c("grappe", "menage")

# 1. left_join 
left_join_res <- individu |>
  left_join(menage, by = cle, suffix = c("_ind", "_men"))

cat(sprintf("left_join  : %d obs x %d vars\n", nrow(left_join_res), ncol(left_join_res)))

# 2. right_join avec la base ménage comme référence
right_join_res <- individu |>
  right_join(menage, by = cle, suffix = c("_ind", "_men"))

cat(sprintf("right_join : %d obs x %d vars\n", nrow(right_join_res), ncol(right_join_res)))

# 3. inner_join 
inner_join_res <- individu |>
  inner_join(menage, by = cle, suffix = c("_ind", "_men"))

cat(sprintf("inner_join : %d obs x %d vars\n", nrow(inner_join_res), ncol(inner_join_res)))

# 4. full_join 
full_join_res <- individu |>
  full_join(menage, by = cle, suffix = c("_ind", "_men"))

cat(sprintf("full_join  : %d obs x %d vars\n", nrow(full_join_res), ncol(full_join_res)))

# 5. semi_join 
semi_join_res <- individu |>
  semi_join(welfare, by = cle)

cat(sprintf("semi_join  : %d obs x %d vars\n", nrow(semi_join_res), ncol(semi_join_res)))

# 6. anti_join 
anti_join_res <- individu |>
  anti_join(welfare, by = cle)

cat(sprintf("anti_join  : %d obs x %d vars\n", nrow(anti_join_res), ncol(anti_join_res)))

# Variables communes entre individu et menage (hors clés)
cles_systeme <- c("grappe", "menage", "hhid", "vague", "country", "year",
                  "region", "milieu")
vars_communes <- intersect(names(individu), names(menage))
vars_communes <- setdiff(vars_communes, cles_systeme)

# Calcul des variables attendues
nb_vars_individu  <- ncol(individu)
nb_vars_menage    <- ncol(menage)
nb_cles           <- length(cle)
nb_vars_communes  <- length(vars_communes)
nb_vars_attendu   <- nb_vars_individu + nb_vars_menage - nb_cles - nb_vars_communes

cat(sprintf("\nVariables individu : %d\n", nb_vars_individu))
cat(sprintf("Variables menage   : %d\n", nb_vars_menage))
cat(sprintf("Clés de jointure   : %d\n", nb_cles))
cat(sprintf("Variables communes (hors clés) : %d\n", nb_vars_communes))
cat(sprintf("Variables attendues après jointure : %d\n", nb_vars_attendu))
cat(sprintf("Variables obtenues (left_join)     : %d\n", ncol(left_join_res)))

# 7. Tableau récapitulatif

recap <- tibble(
  `Type de jointure` = c("left_join", "right_join", "inner_join", 
                         "full_join", "semi_join", "anti_join"),
  
  `Base gauche` = c(
    paste0("individu\n(", format(nrow(individu), big.mark=" "), ", ", ncol(individu), ")"),
    paste0("individu\n(", format(nrow(individu), big.mark=" "), ", ", ncol(individu), ")"),
    paste0("individu\n(", format(nrow(individu), big.mark=" "), ", ", ncol(individu), ")"),
    paste0("individu\n(", format(nrow(individu), big.mark=" "), ", ", ncol(individu), ")"),
    paste0("individu\n(", format(nrow(individu), big.mark=" "), ", ", ncol(individu), ")"),
    paste0("individu\n(", format(nrow(individu), big.mark=" "), ", ", ncol(individu), ")")
  ),
  
  `Base droite` = c(
    paste0("menage\n(", nrow(menage), ", ", ncol(menage), ")"),
    paste0("menage\n(", nrow(menage), ", ", ncol(menage), ")"),
    paste0("menage\n(", nrow(menage), ", ", ncol(menage), ")"),
    paste0("menage\n(", nrow(menage), ", ", ncol(menage), ")"),
    paste0("welfare\n(", nrow(welfare), ", ", ncol(welfare), ")"),
    paste0("welfare\n(", nrow(welfare), ", ", ncol(welfare), ")")
  ),
  
  `Résultat\n(obs, vars)` = c(
    paste0("(", format(nrow(left_join_res), big.mark=" "), ", ", ncol(left_join_res), ")"),
    paste0("(", format(nrow(right_join_res), big.mark=" "), ", ", ncol(right_join_res), ")"),
    paste0("(", format(nrow(inner_join_res), big.mark=" "), ", ", ncol(inner_join_res), ")"),
    paste0("(", format(nrow(full_join_res), big.mark=" "), ", ", ncol(full_join_res), ")"),
    paste0("(", format(nrow(semi_join_res), big.mark=" "), ", ", ncol(semi_join_res), ")"),
    paste0("(", format(nrow(anti_join_res), big.mark=" "), ", ", ncol(anti_join_res), ")")
  ),
  
  `Lignes conservées` = c(
    "Toutes celles de individu",
    "Toutes celles de menage",
    "Intersection",
    "Union",
    "Individus avec ménage dans welfare",
    "Individus sans ménage dans welfare"
  ),
  
  `Colonnes conservées` = c(
    "Les deux bases réunies,\nclés en une fois",
    "Les deux bases réunies,\nclés en une fois",
    "Les deux bases réunies,\nclés en une fois",
    "Les deux bases réunies,\nclés en une fois",
    "Individu uniquement",
    "Individu uniquement"
  )
)
print(recap, n = Inf, width = Inf)

# Style du tableau
style_tab <- function(ft) {
  nrow_ft <- nrow(ft$body$dataset)
  ft |>
    flextable::font(fontname = "Palatino Linotype", part = "all") |>
    flextable::fontsize(size = 9, part = "body") |>
    flextable::fontsize(size = 9.5, part = "header") |>
    flextable::fontsize(size = 8, part = "footer") |>
    flextable::italic(part = "footer") |>
    flextable::bg(bg = col_header, part = "header") |>
    flextable::color(color = blanc, part = "header") |>
    flextable::bold(part = "header") |>
    flextable::align(align = "center", part = "header") |>
    flextable::align(j = 1, align = "left", part = "header") |>
    flextable::bg(i = seq(1, nrow_ft, 2), bg = blanc,     part = "body") |>
    flextable::bg(i = seq(2, nrow_ft, 2), bg = col_clair, part = "body") |>
    flextable::align(j = 1:2, align = "left",    part = "body") |>
    flextable::align(j = 3:5, align = "center",  part = "body") |>
    flextable::bold(j = 1, part = "body") |>
    flextable::border_remove() |>
    flextable::border_outer(part = "all",
                            border = officer::fp_border(color = col_header, width = 1.5)) |>
    flextable::border_inner_h(part = "body",
                              border = officer::fp_border(color = gris_bord, width = 0.4)) |>
    flextable::hline_bottom(part = "header",
                            border = officer::fp_border(color = col_header, width = 2)) |>
    flextable::autofit() |>
    flextable::padding(padding.left = 5, padding.right = 5,
                       padding.top = 3, padding.bottom = 3, part = "all")
}

tab_recap <- flextable(recap) |>
  set_table_properties(layout = "fixed", width = 1) |>
  flextable::add_footer_lines("Source :  ANSD, EHCVM II 2021/2022. Calculs de l'auteure") |>
  set_caption("Tableau récapitulatif des changements suites aux jointures réalisées") |>
  style_tab()

# Export
write.csv(recap, here("outputs", "recap_jointures.csv"), row.names = FALSE)

obs_values <- c(nrow(left_join_res), nrow(right_join_res), nrow(inner_join_res),
                nrow(full_join_res), nrow(semi_join_res), nrow(anti_join_res))
var_values <- c(ncol(left_join_res), ncol(right_join_res), ncol(inner_join_res),
                ncol(full_join_res), ncol(semi_join_res), ncol(anti_join_res))

saveRDS(obs_values, here("data", "obs_values.rds"))
saveRDS(var_values, here("data", "var_values.rds"))
saveRDS(tab_recap, here("data", "tab_recap.rds"))
saveRDS(recap,     here("data", "recap_df.rds"))
saveRDS(ncol(left_join_res), here("data", "nb_vars_left.rds"))
cat("Tableau récapitulatif exporté\n")
