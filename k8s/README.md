# Kubernetes

Aucun manifeste Kubernetes n'a été écrit : le projet tourne dans le service Onyxia `vscode-pyspark` (lancé depuis le catalogue
d'Onyxia, qui crée lui-même le pod), avec Spark en mode `local[*]`. Les valeurs réellement appliquées au pod pour le run du 22/11/2026
sont en `docs/pipeline.md` (« Ressources du run ») ; le quota du namespace, en `docs/historique.md`.
