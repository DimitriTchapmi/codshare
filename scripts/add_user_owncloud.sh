#!/bin/bash
user=$1
PASS=$2
group=$3
cd /var/www/owncloud/
export OC_PASS=$2
su -s www-data -c php occ user:add --password-from-env --display-name=$1 --group=$3 $1