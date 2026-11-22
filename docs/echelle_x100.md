# Et avec 100 fois plus de données ?

## Mesure sur le cluster Onyxia
`src/06_scale.sh` reprend le brut depuis S3, réplique `routes.dat` ×1, ×10 et ×100 sur le disque du service, puis
`src/scale_test.py` rejoue la même requête avec trois exécutions (médiane), sans warm-up. À ×100 : 6 766 300 routes, 237,7 Mo en
CSV et 45,6 Mo en Parquet (301 Mo de disque pour les jeux répliqués). Service `vscode-pyspark`, namespace
`user-r-combe-tamain-ece`, pod à 4 CPU maximum et 3800Mi, driver Spark 3 Go, exécution du **22/11/2026** (18:03–18:04 UTC).
Traces : `results/06_scale.log`, `results/scale_test.csv`. Résultats identiques entre moteurs et formats pour chaque facteur.

| Moteur, format | ×1 | ×10 | ×100 | Croissance ×1 → ×100 |
| --- | ---: | ---: | ---: | ---: |
| DuckDB, Parquet | 162 ms | 178 ms | 299 ms | ×1,8 |
| DuckDB, CSV | 338 ms | 472 ms | 1 959 ms | ×5,8 |
| Spark, Parquet | 767 ms | 630 ms | 854 ms | ×1,1 |
| Spark, CSV | 1 021 ms | 1 079 ms | 3 910 ms | ×3,8 |

Pour un volume multiplié par 100, le temps est multiplié par 1,1 à 5,8 selon le moteur et le format. Le Parquet encaisse mieux la
charge que le CSV (taille divisée par 5,2 à ×100 : 45,6 Mo contre 237,7 Mo). À ×100, DuckDB est plus rapide que Spark dans les deux
formats ; le coût fixe de démarrage de Spark n'est pas inclus dans ces médianes.

**Réserves.** Trois exécutions par point, sans warm-up, et 16 threads Spark sur 4 CPU : les écarts de quelques dizaines de
millisecondes ne sont pas significatifs (par exemple Spark Parquet ×10 plus rapide que ×1). Répliquer les lignes donne des données très
compressibles et très régulières : des données réelles 100 fois plus grosses auraient plus de valeurs distinctes, donc des agrégats
plus coûteux. Les temps mesurés sont des bornes basses, pas des prévisions.

## Ce qui changerait (raisonnement, non mesuré)
- **Volume** : ≈ 390 Mo de CSV brut pour les trois fichiers (3,9 Mo × 100), ≈ 113 Mo en Parquet (rapport 3,5 mesuré à ×1). Cela
  tient sur un seul nœud : le ×100 de `routes.dat` a été traité par le pod de 3800Mi sans incident.
- **Spark** : le gold est écrit en un seul fichier (`coalesce(1)`), acceptable pour 3 199 lignes mais à remplacer par une écriture
  partitionnée si le gold grossit. Le réglage de `shuffle.partitions` n'a pas montré d'effet à 4 Mo ; son effet à ×100 n'est pas mesuré.
- **Stockage** : éviter les petits fichiers ; écrire le brut directement en Parquet partitionné (par pays par exemple).
- **Qualité** : la jointure de validation sur les aéroports reste peu coûteuse tant que `airports` (1 Mo) tient en mémoire ;
  Spark la diffuserait (broadcast). Si cette table devenait aussi grosse, il faudrait une jointure distribuée.
- **Limite du service** : au-delà de quelques gigaoctets, le mode `local[*]` d'un service Onyxia ne suffirait plus ; il faudrait
  un cluster Spark avec plusieurs exécuteurs.
