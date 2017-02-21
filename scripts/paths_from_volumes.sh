#!/usr/bin/env bash

if [ "$PATHS_TO_BACKUP" == "auto" ]; then
  # Determine mounted volumes - build command
  volume_cmd="cat /proc/mounts | grep -oP \"/dev/[^ ]+ \K(/[^ ]+)\""

  # Skip the three host configuration entries always setup by Docker.
  volume_cmd="$volume_cmd | grep -v \"/etc/resolv.conf\" | grep -v \"/etc/hostname\" | grep -v \"/etc/hosts\""

  # remove mounted keyring, if any
  if [ -n "$GPG_KEYRING" ]; then
    volume_cmd="$volume_cmd | grep -v \"$GPG_KEYRING\""
  fi

  # make a space separated list
  volume_cmd="$volume_cmd | tr '\n' ' '"
  volumes=$(eval $volume_cmd)

  if [ -z "$volumes" ]; then
    notifyFailure "No volumes for backup were detected."
    exit 1
  fi

  echo "Volumes for backup: $volumes"
  PATHS_TO_BACKUP=$volumes
fi
