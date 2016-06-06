#!/bin/bash/

nom_user=$1
mdp_user=$2
nom_projet=$3

sudo echo "####Création du Cloud dudev####"
export OC_PASS=$2
cd /var/www/owncloud/
su -s /bin/sh www-data -c "php /var/www/owncloud/occ user:add --password-from-env --display-name="$nom_user" --group="$nom_projet" $nom_user"

sudo useradd $nomuser -G $nom_projet
ligne= `cat /etc/postfix/virtual | grep -n $nom_projet"@codshare.itinet.fr" | cut -d : -f 1`
if grep -q ^$nom_projet@codshare.itinet.fr /etc/postfix/virtual; then
sudo sed -i echo "l$line$nom_user@codshare.itinet.fr," >> /etc/postfix/virtual
else
        sudo echo "Alias inexistant !"
	fi
	sudo echo "####Ajout a l'alias mail du projet####"

	sudo echo "$nom_projet@codshare.itinet.fr $nom_user@codshare.itinet.fr" >> /etc/postfix/virtual


