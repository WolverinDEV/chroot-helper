#!/bin/bash
# Use this script to copy shared (libs) files to Apache/Lighttpd chrooted
# jail server.
# ----------------------------------------------------------------------------
# Written by nixCraft <http://www.cyberciti.biz/tips/>
# (c) 2006 nixCraft under GNU GPL v2.0+
# + Added ld-linux support
# + Added error checking support
# ------------------------------------------------------------------------------
# See url for usage:
# http://www.cyberciti.biz/tips/howto-setup-lighttpd-php-mysql-chrooted-jail.html
# -------------------------------------------------------------------------------

if [[ -z "$JAIL_HOME" ]]; then
    echo "Please specify the jail home (env: JAIL_HOME)"
    exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "Syntax : $0 /path/to/executable"
  echo "Example: $0 /usr/bin/php5-cgi"
  exit 1
fi

[[ ! -d ${JAIL_HOME} ]] && mkdir -p $JAIL_HOME || :

# iggy ld-linux* file as it is not shared one
FILES="$(ldd $1 | awk '{ print $3 }' |egrep -v ^'\(')"

echo "Copying shared files/libs to $JAIL_HOME..."
for i in $FILES
do
  d="$(dirname $i)"
  [[ ! -d ${JAIL_HOME}$d ]] && mkdir -p $JAIL_HOME$d || :
  /bin/cp ${i} "$JAIL_HOME$d"
done

# copy /lib/ld-linux* or /lib64/ld-linux* to $JAIL_HOME/$sldlsubdir
# get ld-linux full file location
sldl="$(ldd $1 | grep 'ld-linux' | awk '{ print $1}')"
# now get sub-dir
sldlsubdir="$(dirname $sldl)"

if [[ ! -f $JAIL_HOME$sldl ]];
then
  echo "Copying $sldl $JAIL_HOME$sldlsubdir..."
  /bin/cp $sldl $JAIL_HOME$sldlsubdir
else
  :
fi

echo "Copying command to jail home"
d="$(dirname $1)"
[[ ! -d ${JAIL_HOME}$d ]] && mkdir -p $JAIL_HOME$d || :
/bin/cp $1 "$JAIL_HOME$1"











