#!/usr/bin/env bash

# Auteur : Julien LOPETRONE
# Date : 19/02/2025   v1.0  // v2.0 06/03/2025
# Contexte : Evalutation ASRBD1 Linux
# Env : VPS OVH
# To DO : re intégrer les fonctions au et faire un switch case séparé / Intégrer un eexecution continue du script aptès l'exécution d'une fonction

# Menu 

function script_banner() {
    echo -e "\e[1;36m"  # Setup de la couleurs
    cat << "EOF"
 ______  _______  ______         ______    ______   _______   ______  _______  ________ 
|      \|       \|      \       /      \  /      \ |       \ |      \|       \|        \
 \$$$$$$| $$$$$$$\\$$$$$$      |  $$$$$$\|  $$$$$$\| $$$$$$$\ \$$$$$$| $$$$$$$\\$$$$$$$$
  | $$  | $$__/ $$ | $$        | $$___\$$| $$   \$$| $$__| $$  | $$  | $$__/ $$  | $$   
  | $$  | $$    $$ | $$         \$$    \ | $$      | $$    $$  | $$  | $$    $$  | $$   
  | $$  | $$$$$$$  | $$         _\$$$$$$\| $$   __ | $$$$$$$\  | $$  | $$$$$$$   | $$   
 _| $$_ | $$      _| $$_       |  \__| $$| $$__/  \| $$  | $$ _| $$_ | $$        | $$   
|   $$ \| $$     |   $$ \       \$$    $$ \$$    $$| $$  | $$|   $$ \| $$        | $$   
 \$$$$$$ \$$      \$$$$$$        \$$$$$$   \$$$$$$  \$$   \$$ \$$$$$$ \$$         \$$   
EOF
    echo -e "\e[0m"  # Réinitialisation de la couleur
}

# Affichage de la bannière
script_banner

# Fonction pour afficher le menu
function show_menu() {
    echo -e "\e[1;33m##############################################################\e[0m"
    echo -e "\e[1;32m#                    MENU PRINCIPAL                          #\e[0m"
    echo -e "\e[1;33m##############################################################\e[0m"
    echo -e "\e[1;34m#    1) \e[1;37mVérifier si un utilisateur est connecté                     \e[0m"
    echo -e "\e[1;34m#    2) \e[1;37mVérifier la présence d’un utilisateur                      \e[0m"
    echo -e "\e[1;34m#    3) \e[1;37mSauvegarde d’un répertoire                                \e[0m"
    echo -e "\e[1;34m#    4) \e[1;37mInstallation d’un serveur LAMP                           \e[0m"
    echo -e "\e[1;34m#    5) \e[1;37mBackup BDD                      \e[0m"
    echo -e "\e[1;34m#    6) \e[1;37mMise à jour et nettoyage du système                      \e[0m"
    echo -e "\e[1;33m##############################################################\e[0m"
}

# Affichage du menu
show_menu
read -p "\e[1;32m Choix : " choix

#Switch case selon le choix effectués
case $choix in 
    1) 
        read -p "Utilisateur : " user
        if who | grep -q "^$user "; then # -q pour ne rien afficher dans le stdout
         echo "Utilisteur : $user est connecté"
         who | grep -q "^$user "
         # Intégrez une fonction qui permet de changer le mot de passe de notre utilisateur ou le proposer !! ####
         read -p "Tuez ce processus ? (y/N)" kill_choix
         if [[ $kill_choix == "y" ]]; then 
            pkill -u $user
            echo "Le processus $user est kill"
         fi 
        else
            echo "Utilisateur introuvable ou non connecté"
        fi
        ;;
    2) 
        read -p "Utilisateur : " user_2
        if grep -q "^$user_2:" /etc/passwd; then
            echo "L'utilisateur : $user_2 est présent dans /etc/passwd"
            groups $user_2 # Vérification de l'appartenance du groupe
        else 
         echo "L'utilisateur $user_2 n'existe pas"
        fi
        ;;
    3)
        read -p "Répertoire a sauvegarder : " path
        if [ -d "$path" ]; then # On vérifie si cela est bien un repertoire
         # On créée un répertoire de sauvegarde dans le /home
         mkdir -p /home/ubuntu/save/
         tar -czf /home/ubuntu/save/$(basename $path)_save.tar.gz "$path"
         echo "Sauvegarde effectué !"
        else 
         echo "Repertoire introuvable !"
        fi
        ;;
    4)
     read -p "Installez LAMP sur ce système ? (y/N)"  lamp_choix
        if [[ $lamp_choix == "y" ]]; then
            if dpkg -l | grep apache2 mysql-server; then # On liste les pakcages installé (debian) puis un grep apache2 pour voir si il est installé
                echo "Serveur LAMP possiblement installé, vérification..."
                sudo systemctl status apache2 mysql
            else
                echo "Installation de LAMP..."
                lamp_install="sudo apt update -y && sudo apt install -y apache2 default-mysql-server php libapache2-mod-php php-mysql" # Package nécessaire pou>
                eval "$lamp_install" # Utilisation d'eval pour exécuter des commandes complexes
                    if [ $? -ne 0 ]; then # On stock la dernière commande est on vérifie si le code d'erreur de bash n'est pas 0 alors il y a une erreur
                        echo "Une erreur s'est produite lors de l'installation"
                    else
                        echo ""
                    fi
                sudo systemctl enable apache2 mysql # On enable les processus dans un premier temps
                sudo systemctl start apache2 mysql # On start les processus
                echo "On vérifie leurs status... \n"
                echo "Apache2's Status"
                sudo systemctl status apache2
                echo "MYSQL's status"
                sudo systemctl status mysql
                echo "Installation effectué avec succès : "
                    # Vérification des versions installé !!#
                echo "Apache2 version : $(apache2 --version | grep 'Serveur version' | awk '{print $3}')"
                echo "MySQL version : $(mysql --version)"

                fi
            fi
        ;;
    5)
        read -p "Définir un dossier de backup : " BACKUP_FOLDER
        if [ ! -d "$BACKUP_FOLDER" ]; then
            echo "Erreur : Le dossier '$BACKUP_FOLDER' n'existe pas !"
            exit 1  # Quitter le script avec un code d'erreur
        fi
        read -p "Veuillez rentrer l'ip du serveur SQL : " DB_IP
        read -p "Entrer le port de connexion : " DB_PORT 
        read -p "Entrer le nom de la base à dump : " DB_NAME
        read -p "Entrer votre Utilisateurs SQL : " DB_USER
        read -s -p "Entrer votre Mot de passe SQL : "  DB_PASSWORD # -s pour pas que le mdp s'affiche à l'écran

        echo "Dump de la base de donnée..."
        DATE=$(date +"%Y-%m-%d_%H-%M-%S") # On définit la date dans une variable

        echo "Le dossier '$BACKUP_FOLDER' existe. Sauvegarde en cours..."
        BACKUP_FILE="$BACKUP_FOLDER/${DB_NAME}_backup_$DATE.sql"
        mysqldump -h "$DB_IP" -P $DB_PORT -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE" # Dump de la save dans le repertoire
        if [ $? -eq 0 ]; then # vérification du fonctionnement du backup
            echo "Sauvegarde réussie : $BACKUP_FILE"
        else
            echo "Échec de la sauvegarde !"
        fi
        ;;
    6)
        # Vérification si le script est exécuté en root
        if [ "$EUID" -ne 0 ]; then
        echo "Ce script doit être exécuté en root !"
        exit 1
        fi
        echo "Mise à jour du système..."
        sudo apt update -y && sudo apt upgrade -y && sudo apt full-upgrade -y
        echo "Nettoyage..."
        sudo apt autoremove -y && sudo apt autoclean -y
        echo "Système mis à jour avec succès !"

    *) echo "Option invalide, veuillez choisir une option valide." ;;

esac

