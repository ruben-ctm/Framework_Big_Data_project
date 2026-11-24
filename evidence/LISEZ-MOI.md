# Dossier evidence

Captures d'écran réelles du **dimanche 22/11/2026**, prises en direct pendant le run (heure de Paris dans la barre de menu de
l'ordinateur, UTC + 1 ; les journaux `results/*.log` sont en UTC). Namespace Onyxia : `user-r-combe-tamain-ece`. Pod :
`vscode-pyspark-198275-0` (CPU 100m / 4000m, mémoire 400Mi / 3800Mi). Terminal vidé (`clear`) avant chaque étape. Les captures
n'ont été ni recadrées ni retouchées par l'équipe. Elles remplacent entièrement les captures d'un passage antérieur non
retenu (voir `docs/historique.md`).

| N° | Contenu | Heure (Paris) |
| --- | --- | --- |
| `01` | Onyxia, Mes services : `vscode-pyspark` et quotas du namespace | 19:06 |
| `02a` | Terminal : namespace, `date`, `nproc` (16), `cpu.max` et `memory.max`, `SPARK_DRIVER_MEMORY` (3g) | 18:54 |
| `02b` | Terminal : commit `d1338ea` (driver 3g) poussé | 18:56 |
| `02c` | Terminal : `git log -1` et `git status` avant le run | 18:56 |
| `03` | Terminal : `01_ingest` (manifeste, envoi S3, `OK`) | 18:57 |
| `03b` | Terminal : réaffichage à 18:52 du journal `01_ingest` du **passage préliminaire** du 22/11 (17:22 UTC), mis de côté ; ne correspond pas à `results/` ; conservée pour transparence, la capture `03` fait foi | 18:52 |
| `04` | Terminal : `02_silver` (rapport qualité, 66 771 valides / 892 rejetées) | 18:58 |
| `05` | Terminal : `03_gold` (top 10 des hubs, `GOLD OK hubs=3199`) | 18:59 |
| `06` | Terminal : `04_benchmark` (5 exécutions, résultats identiques : OUI) | 19:00 |
| `07` | Terminal : `05_verify` (7 contrôles sur 7 ; lignes longues coupées à l'écran, le journal est complet) | 19:03 |
| `08` | Terminal : `06_scale` (DuckDB et Spark ×1/×10/×100) | 19:04 |
| `09` | Terminal : `steps.tsv` (six `OK`) et `ls -l results/` | 19:05 |
| `10` | Onyxia, Stockage de données : racine du bucket | 19:07 |
| `11` | Onyxia : `openflights/raw/` | 19:08 |
| `12` | Onyxia : `openflights/silver/` (5 dossiers) | 19:08 |
| `13` | Onyxia : `openflights/gold/hubs/` | 19:08 |
| `14` | Terminal : `src_code IST 358` (routes de l'aéroport 1701, code IATA `ISL`) | 19:00 |

Remarques.
- Les captures `01`, `10` à `13` (interface Onyxia) montrent le namespace dans l'URL ; les captures de terminal le montrent dans les
  lignes `==` des journaux et dans le nom du pod du prompt.
- Dans la racine du bucket (`10`), seul `openflights/` appartient au projet.
- Aucun redémarrage de conteneur n'a été observé pendant ce run ; aucune capture des événements du namespace n'est fournie.
- L'ordre des heures : chaque capture d'étape est prise juste après `FIN` ; pour `07` l'horloge est environ une minute après la fin du journal.
- La capture `02b` montre le hash `d1338ea` de l'historique antérieur à sa reconstruction ; il n'est plus présent dans la branche actuelle.

## Origine des fichiers de ce dossier
Les PNG ci-dessus ont été obtenus par **conversion en PNG** (sans recadrage ni retouche) des images transmises pendant la session de
travail, reçues au format WebP : les pixels sont ceux des images reçues, mais ce ne sont pas les fichiers PNG d'origine de l'ordinateur
de Ruben, qui doivent être substitués à ceux-ci si disponibles (mêmes noms). Elles remplacent les 15 PNG d'un passage antérieur non retenu.
