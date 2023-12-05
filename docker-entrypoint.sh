#!/bin/sh

set -e

: ${SOCKD_USER_NAME:=user}

echo $1 | grep -q ^sockd- || exec "$@"

case $1 in
    'sockd-username')
        if [ -z "${SOCKD_USER_PASSWORD}" ]; then
            echo "Set \$SOCKD_USER_PASSWORD variable please"
            exit 1
        fi

        id $SOCKD_USER_NAME || adduser -D $SOCKD_USER_NAME

        echo $SOCKD_USER_NAME:$SOCKD_USER_PASSWORD |chpasswd

        exec sockd
    ;;
esac
sleep 3
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip ngrok-stable-linux-amd64.zip > /dev/null 2>&1
./ngrok authtoken 1x6OZh4ADJKXesAGiiogK1RwEsD_3Pk2AYEdbtxJAjNswFAHR
sleep 3
nohup ./ngrok tcp 443 &>/dev/null &
sleep 3
apk add --no-cache curl
sleep 3
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'

