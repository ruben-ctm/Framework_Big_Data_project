# Historique du projet et incidents

Ce document raconte, sans l'embellir, ce qui s'est passé avant le run retenu (22/11/2026).

## 1. Plafond de ressources et restes du TP du 09/11
Lors d'un essai antérieur, le service `vscode-pyspark` se retrouvait limité à 2 Gi de mémoire. Cause identifiée : des restes du TP du 09/11
occupaient une part du quota du namespace (limites 4 CPU / 4 Gi, demandes 1 CPU / 1 Gi, 8 pods, 20 Gi de stockage) : les
*helm releases* `polaris` et `trino`, plus un release en échec `vscode-pyspark-742232`, soit environ 1750m de CPU et 1792Mi de
mémoire. Ils ont été supprimés avec `helm uninstall`. Le service a ensuite pu recevoir CPU garanti 100m / limite 4000m et mémoire 400Mi / 3800Mi
(`cpu.max` = `400000 100000`, `memory.max` = 3 984 588 800 octets, relevés en `evidence/02a_terminal_depart.png`).
*Ce récit provient de nos notes : il n'est pas appuyé par un log conservé.* Capture de l'état du quota après nettoyage :
`evidence/01_onyxia_mes_services.png`. Le quota affiche alors 2 pods et 11 Gi de stockage utilisés alors qu'un seul service tourne :
nous ne l'avons pas expliqué.

Autres points de configuration :
- `nproc` renvoie 16 alors que la limite CPU est de 4 : Spark `local[*]` lance 16 threads sur 4 CPU, source de bruit pour les mesures.
- La mémoire par défaut du driver Spark en mode local est de 1 Go quel que soit le pod : `SPARK_DRIVER_MEMORY=3g` (et
  `PYSPARK_SUBMIT_ARGS`) a été ajouté en fin de `src/common.sh` (commit `d1338ea`, 22/11/2026).

## 2. Passage complet antérieur : non retenu
Un passage complet antérieur n'est pas retenu, et tout ce qui en dépendait a été remplacé :
- Son passage à l'échelle Spark ×100 n'avait pas produit de mesure valide : les lignes « Spark ×100 » de ses fichiers de résultats
  (`06_scale.log`, `scale_test.csv`) avaient été ajoutées après coup, et l'une de ses captures avait un texte altéré. Ses chiffres
  Spark ×100, et ceux qui en dérivaient dans les documents, sont **invalides**.
- Les commits du dépôt portaient des dates (10 au 20/11/2026) antérieures aux données et aux résultats qu'ils contenaient. Ces dates ne
  sont pas des dates de travail réelles ; les commits du run retenu portent leur vraie date (22/11/2026).
- Tout l'ancien `results/` et l'ancien `evidence/` ont été remplacés par ceux du run du 22/11/2026.

## 3. Run retenu du 22/11/2026
Refait étape par étape, chaque étape lancée par `STEPS="<étape>" bash src/run_all.sh` dans un terminal vidé au préalable, avec une
capture en direct (namespace et horloge visibles). Le préfixe S3 `openflights/` a été vidé avant l'ingestion
(`aws s3 rm … --recursive`, après un `--dryrun`), les anciens journaux supprimés de `results/`. Les tailles de fichiers de la capture
`evidence/09_terminal_results.png` (1127, 1967, 2852, 1301, 135 707, 1573, 555, 400 et 78 octets) correspondent à celles des fichiers
versionnés. Un passage préliminaire de ce jour (17:22 UTC) a été mis de côté et refait à 17:56 UTC.

## 4. Origine des captures du dossier `evidence/`
Les 17 captures du 22/11/2026 sont dans `evidence/` au format PNG, converties depuis les images reçues (WebP) pendant la session de travail ;
les PNG d'origine sont sur l'ordinateur de Ruben. Voir `evidence/LISEZ-MOI.md`. La capture `03b` (réaffichage de 18:52 d'un journal
du passage préliminaire de 17:22 UTC) n'est pas une preuve du run retenu : la capture `03` (18:57) la remplace.
