#!/bin/bash

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab

# Following the following official gcloud instructions:
# https://cloud.google.com/sdk/downloads

readonly PROGNAME=$(basename "$0")
readonly PROJECTDIR="$( cd "$(dirname "$0")" || exit ; pwd -P )"

readonly TMP_DIR="/tmp"
readonly BIN_DIR="$HOME/bin"
readonly TAR_CMD=$(which tar)
readonly WGET_CMD=$(which wget)

readonly GCLOUD_VERSION="156.0.0"
readonly GCLOUD_CHECKSUM="34a59db03cdc5ef7fc32ef90b98eaf9e4deff83f"
readonly DOWNLOAD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz"
readonly DOWNLOADED_FLE="$TMP_DIR/gcloud.tar.gz"

if [ "$(id -u)" == "0" ]; then
  echo "This script must be run as an unprivileged user" 1>&2
  exit 1
fi

if [ ! -d "$BIN_DIR" ]; then
  mkdir -p "$BIN_DIR"
fi

"$WGET_CMD" -O "$DOWNLOADED_FLE" "$DOWNLOAD_URL"

#md5=$(md5sum ${DOWNLOADED_FLE} | awk '{ print $1 }')
#if [ "$md5" != "$GCLOUD_CHECKSUM" ]; then
#  echo "Checksum of downloaded file was not expected value of $GCLOUD_CHECKSUM" 1>&2
#  exit 1
#fi

"$TAR_CMD" -xzf "$DOWNLOADED_FLE" -C "$BIN_DIR"
if [ ! -f "$BIN_DIR/google-cloud-sdk/install.sh" ]; then
  echo "gcloud install script was not found!" 1>&2
  exit 1
fi

"$BIN_DIR/google-cloud-sdk/install.sh" --usage-reporting true --command-completion true --path-update true --rc-path "$HOME/.bashrc" --quiet 
rm "$DOWNLOADED_FLE"

if [ ! -f "$BIN_DIR/google-cloud-sdk/bin/gcloud" ]; then
  echo "new gcloud executable was not found!" 1>&2
  exit 1
fi

"$BIN_DIR/google-cloud-sdk/bin/gcloud" components install kubectl --quiet
