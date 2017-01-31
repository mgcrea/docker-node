#!/bin/bash

# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# allow user override on docker start
if [[ $UID != "33" ]]; then
	usermod -u $UID $NODE_USER
fi
if [[ $GID != "33" ]]; then
	usermod -g $GID $NODE_USER
fi

# set permissions so that we have access to volumes
NODE_CHOWN_VOLUME=${NODE_CHOWN_VOLUME:-"no"}
if [[ $NODE_CHOWN_VOLUME == "yes" ]]; then
	chown -R $NODE_USER:$NODE_GROUP /srv/www;
fi

gosu $NODE_USER /usr/local/bin/node $@
