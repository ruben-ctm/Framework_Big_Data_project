#!/usr/bin/env bash
# Script d'initialisation Onyxia facultatif.
# Clone le depot sur le disque du service et lance une execution unique en arriere-plan.
W="${HOME:-/home/onyxia}/work"
PROJECT="Framework_Big_Data_project"
mkdir -p "$W"
nohup setsid bash -c '
  cd "'"$W"'" && rm -rf "'"$PROJECT"'" &&
  git clone -q --depth 1 https://github.com/ruben-ctm/Framework_Big_Data_project.git &&
  cd "'"$PROJECT"'" && bash src/onyxia_run.sh
' > "$W/Framework_Big_Data_project_run.out" 2>&1 &
exit 0
