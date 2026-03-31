# TP 1 Individuel : Plan de sondage et jointures de bases

Ce TP est pour le compte du cours intitulé **Projet Statistique avec R & Python**, dispensé par M. Aboubacar HEMA qui est research scientist à IFPRI.

**Auteure** : Nkwa Tsamo Leslye Patricia, ISE1 CL

## 1. Source de données

Les données mobilisées sont les bases `ehcvm_menage_SEN2021.dta`, `ehcvm_individu_SEN2021.dta`, `ehcvm_welfare_SEN2021.dta` et `ehcvm_conso_SEN2021.dta`. Toutes proviennent de l'**Enquête Harmonisée sur les Conditions de Vie des Ménages, édition 2 (EHCVM-II) 2021/2022 du Sénégal**, réalisée par l'ANSD en collaboration avec la Banque mondiale et l'UEMOA.

Pour des soucis de légèreté, les données ont été placées dans le `.gitignore`.
Vous pouvez accéder aux données via le catalogue de la Banque mondiale : <https://microdata.worldbank.org/index.php/catalog/6278>

## 2. Objectifs de ce TP

1. Présenter le plan de sondage de l'EHCVM 2021/2022 (stratification, tirage à deux degrés, pondération).
2. Explorer la structure des quatre bases et leurs relations (1:1, 1:N).
3. Réaliser les différents types de jointures en R (left, right, inner, full, semi, anti) et interpréter l'effet de chaque jointure sur le nombre d'observations et de variables.

## 3. Reproductibilité

### Étape 1 : Cloner le dépôt

```bash
git clone <url-du-depot>
cd TP1_INDIV_LESLYE_NKWA
```

### Étape 2 : Restaurer l'environnement R

Ouvrir `TP1_INDIV.Rproj` dans RStudio, puis dans la console R, tapez :

```r
renv::restore()
```

Cette commande installe automatiquement **toutes les dépendances** avec les versions exactes utilisées au cours du travail et spécifiées dans `renv.lock`. Aucune installation manuelle de packages n'est nécessaire.

### Étape 3 : Placer les données brutes

Télécharger les 4 fichiers `.dta` (voir section Source de données) et les placer dans :

```
data/
```

### Étape 4 : Exécuter le pipeline complet

```r
source("main.R")
```

Ce script :
- Vérifie que tous les packages sont installés (sinon, demande de taper `renv::restore()`)
- Charge les packages requis
- Fixe la graine aléatoire (`set.seed(2070)`) pour la reproductibilité
- Exécute `preparation.R` : import des bases, vérification de l'unicité des clés, définition du plan de sondage
- Exécute `analyses.R` : jointures, tableau récapitulatif, export des résultats
- Génère le `rapport.Rmd` en Word complet et stylisé

## 4. Structure locale du projet

```
TP1_INDIV_LESLYE_NKWA
├── data/
│   ├── les 4 fichiers .dta
│   ├── des fihciers .rds
├── docs/
│   ├── Extrait_Rapport_Final_Senegal_EHCVM_2021.pdf
│   ├── rapport.docx  
│   ├── rapport.Rmd
│   ├── reference.docx    # Fichier de styles prédéfinis
├── outputs/
│   ├── recap_jointures.csv    # Tableau récapitulatif des jointures
├── renv/
├── scripts/
│   ├── analyses.R
│   ├── preparation.R
├── .gitignore
├── .Rhistory
├── .Rprofile
├── main.R
├── README.md
├── renv.lock
├── TP1_INDIV_LESLYE_NKWA.Rproj
```

## 5. Résultats principaux

Les résultats sont dans docs/rapport.docx. Ce TP nous a permis d'appliquer les jointures avec le logiciel R et de comprendre le plan de sondage de l'EHCVM.

## 6. Crédit

ENSAE de Dakar.