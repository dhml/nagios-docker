#!/usr/bin/env bash

set -e

if [ -n "$MSMTP_HOST" -a -n "$MSMTP_FROM" ]
then
  cat <<EOF > /etc/msmtprc
account default
host $MSMTP_HOST
from $MSMTP_FROM
EOF
fi

exec "$@"
