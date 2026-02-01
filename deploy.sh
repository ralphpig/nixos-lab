#!/usr/bin/env bash
set -e

if [[ -z "${NIXOS_HOST:-}" ]]; then
  echo "NIXOS_HOST environment variable must be set (user@host.domain.com)" >&2
  exit 1
fi

rsync -rv \
  --delete \
  --rsync-path="sudo rsync" \
  ./secrets/ ${NIXOS_HOST}:/etc/credentials/;

rsync -rv \
  --delete \
  --exclude './secrets/' \
  --rsync-path="sudo rsync" \
  ./ ${NIXOS_HOST}:/etc/nixos/;

nixos-rebuild \
  --target-host ${NIXOS_HOST} \
  --build-host ${NIXOS_HOST} \
  -I nixos-config=./configuration.nix switch;
