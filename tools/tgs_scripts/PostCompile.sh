#!/bin/bash
# TGS event script: runs after a successful compile, $1 is the deployment directory.
# Bundle publishing must never fail a deployment, so errors are only logged.
# Settings (CDN_BASE_URL etc., see tools/deploy_asset_bundles.sh) can be exported
# by the TGS service or put into asset_bundles.env next to this script.

env_file="$(dirname "$0")/asset_bundles.env"
if [ -f "$env_file" ]; then
	# Strip CR so a file saved with Windows line endings doesn't leak \r into values
	set -a
	. <(tr -d '\r' < "$env_file")
	set +a
fi

if [ -z "${CDN_BASE_URL:-}" ]; then
	echo "CDN_BASE_URL is not set, skipping asset bundle deploy"
	exit 0
fi

bash "$1/tools/deploy_asset_bundles.sh" "$1" || echo "Asset bundle deploy failed, continuing without it"
exit 0
