#!/usr/bin/env bash

set -e

# only configure msmtp if running with default command
if [ "$*" = "/usr/bin/supervisord" ]
then

  : "${MSMTP_HOST:?"MSMTP_HOST must be set in the environment"}"
  : "${MSMTP_FROM:?"MSMTP_FROM must be set in the environment"}"

  cat <<EOF > /etc/msmtprc
account default
host $MSMTP_HOST
from $MSMTP_FROM
EOF

fi

exec "$@"
