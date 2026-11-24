# Framework Big Data : hubs aériens mondiaux

> Dernière vérification complète : 22/11/2026.

## Auteurs

COMBE-TAMAIN Ruben, REVERSAT Antoine, DREAN-AVRILLON Edwin.

## Prérequis

- Compte Onyxia (Datalab) avec un bucket S3 personnel, ici `user-r-combe-tamain-ece`.
- Service **`vscode-pyspark`** (Spark, Python 3, `aws`, `git` inclus). Configuration du run du 22/11/2026 :
  CPU garanti 100m / limite 4000m, mémoire garantie 400Mi / limite 3800Mi. Le driver Spark en mode `local[*]` reçoit 3 Go
  (`SPARK_DRIVER_MEMORY=3g`, défini par défaut dans `src/common.sh`) : sans cela Spark est limité à 1 Go quel que soit le pod.
- Quota du namespace pour ce run : limites 4 CPU / 4 Gi, demandes 1 CPU / 1 Gi, 8 pods, 20 Gi de stockage. Un quota occupé
  par d'autres services (voir `docs/historique.md`) plafonne le pod : supprimer les services inutiles avant de lancer.
- `duckdb` et `pyarrow` sont installés au besoin par `src/common.sh` (accès réseau pip requis).

## Dataset

**OpenFlights** (airports, airlines, routes) : https://github.com/jpatokal/openflights, dossier `data/`. Licence **ODbL**.
Téléchargé le **22/11/2026** (17:56 UTC) depuis la branche `master` : 81 523 lignes, **3 901 269 octets (3,9 Mo)**.
Date, tailles et SHA-256 : `data/raw/MANIFEST.txt`.

## Problématique

Quels aéroports sont les principaux hubs par routes sortantes ? Quelle part des routes est invalidée par le nettoyage ?
La montée en charge change-t-elle les performances des moteurs testés ?

## Chemins S3

- Brut : `s3://user-r-combe-tamain-ece/openflights/raw/` (3 `.dat` + `MANIFEST.txt`).
- Silver : `s3://user-r-combe-tamain-ece/openflights/silver/` (`airports`, `airlines`, `routes`, `routes_rejected`, `quality_report`).
- Gold : `s3://user-r-combe-tamain-ece/openflights/gold/hubs/`.

## Reproduire

0. **Onyxia** : Catalogue de services → `vscode-pyspark` → régler CPU/mémoire (ci-dessus) → Lancer → Ouvrir, puis, dans un terminal :
```bash
git clone https://github.com/ruben-ctm/Framework_Big_Data_project.git && cd Framework_Big_Data_project
bash src/run_all.sh        # les 6 étapes ; les traces datées vont dans results/
```
1. Étapes : `01_ingest` (téléchargement, manifeste, envoi S3) → `02_silver` (Spark) → `03_gold` (Spark) → `04_benchmark`
   (Spark, DuckDB) → `05_verify` (DuckDB, indépendant) → `06_scale` (×1, ×10, ×100).
2. **Sortie attendue** : chaque étape se termine par `FIN <étape>`, puis `results/steps.tsv` liste six `OK` ;
   `02_silver` affiche `SILVER OK routes_valides=66771 routes_rejetees=892`, `03_gold` `GOLD OK hubs=3199`,
   `05_verify` `VERIFICATION : 7/7 controles OK`.
3. **Durée** : 3 min 18 s de calcul pour les six étapes (somme des étapes du run du 22/11/2026, `results/*.log`).
4. **Redémarrer une étape** : `STEPS="05_verify" bash src/run_all.sh` (accepte plusieurs étapes). Les journaux s'ajoutent à la
   suite ; pour repartir propre, supprimer `results/<étape>.log` d'abord. `01_ingest` réécrit le brut sur S3 ; `02` et `03` écrasent silver et gold.
   Variables : `BUCKET`, `PREFIX`, `BENCH_RUNS=5`, `BENCH_SEED`, `SPARK_MAX_FACTOR=100`, `SPARK_DRIVER_MEMORY=3g`.
   `data/raw/*.dat` est ignoré par Git.

## Résultats (run du 22/11/2026)

67 663 routes : 66 771 valides, 892 rejetées (1,32 %) ; ATL en tête avec 915 routes sortantes (217 destinations distinctes).
Rapport : [PDF](report/RapportProjet_COMBE-TAMAIN_REVERSAT_DREAN-AVRILLON.pdf). Détails : [qualité](docs/qualite.md),
[mesures](docs/mesures.md), [pipeline](docs/pipeline.md), [×100](docs/echelle_x100.md), [historique et incidents](docs/historique.md).
Preuves : [evidence/](evidence/) (captures), [results/](results/) (traces). Tests : `python3 -m unittest discover -s tests`.
