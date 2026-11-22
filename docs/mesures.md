# Mesures et choix techniques

Requête mesurée : top 10 des aéroports par routes sortantes, même résultat vérifié pour tous les moteurs et formats
(« Résultats identiques : OUI » dans `results/04_benchmark.log`). Exécution du **22/11/2026** (18:00 UTC) sur Onyxia, service
`vscode-pyspark` du namespace `user-r-combe-tamain-ece` : CPU garanti 100m / limite 4000m, mémoire 400Mi / 3800Mi
(`memory.max` = 3 984 588 800 octets), driver Spark 3 Go. Cinq exécutions par variante après un warm-up hors mesure, ordre
des variantes aléatoire reproductible (`BENCH_SEED`). Source : `results/benchmark.csv`.

| Variante | Exécutions (ms) | Médiane (ms) | Min (ms) |
| --- | --- | ---: | ---: |
| Spark, Parquet, `shuffle.partitions = 8` | 717 ; 753 ; 641 ; 569 ; 537 | 641 | 537 |
| Spark, Parquet, `shuffle.partitions = 200` (défaut) | 611 ; 586 ; 614 ; 603 ; 527 | 603 | 527 |
| Spark, CSV brut, `shuffle.partitions = 8` | 634 ; 899 ; 618 ; 684 ; 596 | 634 | 596 |
| DuckDB, Parquet | 17 ; 15 ; 16 ; 15 ; 14 | 15 | 14 |
| DuckDB, CSV brut | 321 ; 341 ; 339 ; 335 ; 342 | 339 | 321 |

Autres mesures : démarrage de la session Spark 8 398 ms ; CSV brut 3 901 269 octets contre 1 129 655 octets pour le silver
Parquet (3,5 fois plus petit).

**Biais connu.** La requête sur CSV valide les deux extrémités de chaque route (deux jointures), celle sur Parquet lit des
routes déjà validées (une jointure). L'écart CSV/Parquet mélange donc format et validation ; il n'a pas été corrigé dans ce run.

**Lectures** (rapports calculés à partir des médianes ci-dessus).
- **Spark, Parquet contre CSV** : 641 ms contre 634 ms à 8 partitions, aucun écart mesurable (les plages d'exécutions se recouvrent).
- **`shuffle.partitions`** : 603 ms avec 200 partitions contre 641 ms avec 8 ; les plages se recouvrent, on ne conclut pas à un gain
  de l'un ou de l'autre à cette taille.
- **DuckDB, Parquet contre CSV** : 15 ms contre 339 ms, soit environ 23 fois (en partie due au biais ci-dessus).
- **DuckDB contre Spark sur le même Parquet** : 15 ms contre 603 à 641 ms, soit environ 40 à 43 fois. Spark met 8,4 s à démarrer,
  donc son surcoût domine sur 4 Mo.

**Limites.** Cinq exécutions, de l'ordre de la milliseconde à la centaine de millisecondes : le bruit compte. Le pod voit
16 cœurs (`nproc`) pour une limite CPU de 4 : Spark `local[*]` lance 16 threads sur 4 CPU, source de variabilité que nous
n'avons pas contrôlée.

**Alternatives écartées.**
- *Trino et Polaris* : non mesurés dans ce projet. Ils avaient été déployés lors d'un TP le 09/11 ; leurs restes ont saturé le
  quota du namespace (voir [historique](historique.md)). Aucun log de ce TP n'est conservé.
- *Spark seul, sans DuckDB* : écarté pour la vérification indépendante, qui doit utiliser un autre moteur et un autre code.
- *Delta ou Iceberg à la place de Parquet* : non retenu, aucun besoin de transactions ni de voyage dans le temps sur 4 Mo ; non mesuré.
- *Polars ou Pandas* : non mesurés.

Voir [passage à l'échelle](echelle_x100.md).
