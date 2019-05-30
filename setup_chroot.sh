#!/usr/bin/env bash


JAIL_HOME="$1"
if [[ -z "$JAIL_HOME" ]]; then
    echo "Please specify a location!"
    exit 1
fi

#Prevent client from going up
chown root:root $JAIL_HOME
chmod 0755 $JAIL_HOME

# Basic required stuff
mkdir -p $JAIL_HOME/dev/
mknod -m 666 $JAIL_HOME/dev/null c 1 3
mknod -m 666 $JAIL_HOME/dev/tty c 5 0
mknod -m 666 $JAIL_HOME/dev/zero c 1 5
mknod -m 666 $JAIL_HOME/dev/random c 1 8

# Install nns files
mkdir -p $JAIL_HOME/lib/x86_64-linux-gnu/
cp -va /lib/x86_64-linux-gnu/libnss_files* $JAIL_HOME/lib/x86_64-linux-gnu/