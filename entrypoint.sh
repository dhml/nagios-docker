#!/usr/bin/env bash

set -e

: "${MSMTP_HOST:?"MSMTP_HOST must be set in the environment"}"
: "${MSMTP_FROM:?"MSMTP_FROM must be set in the environment"}"

cat <<EOF > /etc/msmtprc
account default
host $MSMTP_HOST
from $MSMTP_FROM
EOF

exec "$@"
