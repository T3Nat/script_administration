# script_administration

# 🚀 Script d'Administration Linux

## 📌 Description
Ce script Bash automatise plusieurs tâches d'administration système sur une machine Linux, notamment :
- 📡 Vérification de la connexion des utilisateurs
- 👤 Recherche d'un utilisateur dans `/etc/passwd` et ses groupes
- 📂 Sauvegarde de répertoires
- 🔧 Installation et vérification d'un serveur **LAMP** (Apache, MySQL, PHP)
- 💾 Backup et restauration de bases de données **MySQL**
- 🔄 Mise à jour et nettoyage du système

## 🛠️ Prérequis
Ce script est conçu pour fonctionner sur **Ubuntu/Debian** et nécessite :
- Un accès **root** ou des droits `sudo`
- `tar`, `mysqldump`, `systemctl`, `dpkg`

## 📥 Installation
Clonez ce dépôt et rendez le script exécutable :
```bash
# Clone le dépôt
git clone https://github.com/TON_NOM_UTILISATEUR/script-administration-linux.git
cd script-administration-linux

# Donner les droits d'exécution
chmod +x script.sh
```

## ▶️ Utilisation
Exécutez le script en tant que **root** :
```bash
sudo ./script.sh
```
Un menu interactif apparaîtra avec plusieurs options :
1️⃣ Vérifier si un utilisateur est connecté
2️⃣ Vérifier si un utilisateur existe dans `/etc/passwd`
3️⃣ Sauvegarder un répertoire
4️⃣ Installer un serveur LAMP
5️⃣ Sauvegarde d'une base de données SQL
6️⃣ Mettre à jour le système

## 🏗️ Fonctionnalités détaillées
### 🔎 Vérification des utilisateurs
- Vérifie si un utilisateur est connecté
- Propose de **tuer** ses processus si nécessaire

### 📂 Sauvegarde de répertoires
- Archive un dossier donné dans `/home/save/`
- Compression au format `.tar.gz`

### 🖥️ Installation de LAMP
- Installe `Apache2`, `MySQL`, `PHP` et les modules nécessaires
- Vérifie l'installation et affiche les versions

### 💾 Backup MySQL
- Demande les infos de connexion (IP, port, user, password)
- Sauvegarde la base de données dans un fichier `.sql`

### 🛠️ Mise à jour du système
- Exécute `apt update && apt upgrade -y`
- Effectue un nettoyage post-mise à jour

## 📜 Exemple de sortie du script
```
--- MENU PRINCIPAL ---
1) Vérifier utilisateur
2) Rechercher utilisateur
3) Sauvegarde répertoire
4) Installer LAMP
5) Sauvegarde MySQL
6) Mise à jour du système
Choisissez une option :
```

## 📝 Notes
- **Vérifiez vos accès `sudo`** avant de lancer certaines actions critiques.
- Le script est optimisé pour **Ubuntu/Debian**, mais peut être modifié pour d'autres distributions.
- En cas de bug, ouvrez une **issue** sur ce dépôt GitHub.

## 📜 Licence
Ce script est sous licence **MIT** – vous êtes libre de le modifier et de l'améliorer ! 🚀

