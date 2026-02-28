#!/bin/bash

set -Eeuo pipefail

cd ${COMFYUI_PATH}

mkdir -vp /data/custom_nodes
mkdir -vp /data/user

declare -A MOUNTS

MOUNTS["/root/.cache"]="/data/.cache"
MOUNTS["${COMFYUI_PATH}/custom_nodes"]="/data/custom_nodes"
MOUNTS["${COMFYUI_PATH}/input"]="/data/input"
MOUNTS["${COMFYUI_PATH}/models"]="/data/models"
MOUNTS["${COMFYUI_PATH}/user"]="/data/user"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  echo "Mounting $from_path --> $(dirname "$to_path")"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    #echo "$from_path doesn't exist."
    mkdir -p "$from_path"
  fi
  if [ ! -f "$to_path" ]; then
    #echo "$(dirname "$to_path") doesn't exist."
    mkdir -p "$(dirname "$to_path")"
  fi
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

if [ -f "/data/startup.sh" ]; then
  pushd ${COMFYUI_PATH}
  . /data/startup.sh
  popd
fi

. ${COMFYUI_PATH}/venv/bin/activate
exec "$@"