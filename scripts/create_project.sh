#!/bin/bash

depot_git="/var/www/git/"
depot_site="/var/www/site/"
dossier_keys="/home/codshare-itinet/"

nom_user=$1
nom_projet=$2
mdp_user=$3

###Création du compte Unix du chef de projet###
if grep -q ^$nom_user /etc/passwd; then
	sudo echo "User $nom_user already exist in /etc/passwd !"
else
	sudo useradd -p $mdp_user -d /home/$nom_user -s /usr/bin/mysecureshell $nom_user 
	#changing to encrypted password
    sudo echo "$nom_user:$mdp_user" | sudo chpasswd
fi

sudo echo "####Création du groupe Unix pour le projet####"
sudo useradd --create-home $nom_projet
sudo mkdir /home/$nom_projet/.ssh
chmod 700 /home/$nom_projet/.ssh
chown -R $nom_projet:$nom_projet /home/$nom_projet/.ssh

sudo echo "###Création du depot_site du projet###"
sudo mkdir $depot_site$nom_user
chmod -R 750 $depot_site$nom_user
sudo chown -R $nom_user:www-data $depot_site$nom_user

sudo echo "####Création de l'Alias mail du projet####"
sudo echo "$nom_projet@codshare.itinet.fr $nom_user@codshare.itinet.fr" >> /etc/postfix/virtual
sudo postmap /etc/postfix/virtual
sudo postfix reload

sudo echo "####Création du dossier Cloud du projet####"
export OC_PASS=$1
cd /var/www/owncloud/
su -s /bin/sh www-data -c "php /var/www/owncloud/occ user:add --password-from-env --display-name="$nom_user" --group="$nom_projet" $nom_user"

sudo echo "####Création du Depôt Git du projet####"
sudo mkdir $depot_git$nom_projet
cd $depot_git$nom_projet
git init --bare
sudo echo ""
chmod -R 770 $depot_git$nom_projet
chown -R $nom_user:$nom_projet $depot_git$nom_projet

#Ajout chef key to authorized keys

sudo echo $dossier_keys$nom_user > /home/$nom_projet/.ssh/authorized_keys
sudo chmod 664 /home/$nom_projet/.ssh/authorized_keys
chown -R $nom_projet:$nom_projet /home/$nom_projet/.ssh/authorized_keys
