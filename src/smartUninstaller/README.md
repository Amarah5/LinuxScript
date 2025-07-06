# 🧰 Désinstallateur Intelligent pour Linux

Un outil interactif en ligne de commande (TUI) pour désinstaller des logiciels sur les systèmes Linux basés sur Debian/Ubuntu, prenant en charge les paquets `apt`, `snap` et `flatpak`.

## 🌟 Fonctionnalités

* **Désinstallation Multi-Gestionnaire :** Détecte et désinstalle les logiciels installés via `apt`, `snap` ou `flatpak`.
* **Recherche Partielle :** Vous permet de rechercher un logiciel en entrant une partie de son nom.
* **Sélection Interactive :** Présente une liste numérotée des correspondances trouvées pour une sélection facile via une interface `whiptail`.
* **Nettoyage Automatique :** Exécute `apt autoremove` après chaque opération pour supprimer les dépendances inutiles.
* **Interface Conviviale :** Utilise `whiptail` pour une expérience utilisateur améliorée dans le terminal.
* **Lanceur d'Application :** Peut être ajouté à votre menu d'applications avec une icône dédiée.

## 🚀 Installation

Suivez ces étapes pour installer et utiliser le Désinstallateur Intelligent sur votre système :

1.  **Créez le dossier du projet :**
    ```bash
    mkdir -p ~/script/uninstaller
    cd ~/script/uninstaller
    ```

2.  **Téléchargez les fichiers du projet :**
    Si vous clonez ce dépôt GitHub, vous obtiendrez tous les fichiers. Sinon, téléchargez `uninstaller.sh`, `uninstaller_ico.png` et `uninstaller.desktop` dans ce dossier.

3.  **Rendez le script exécutable :**
    ```bash
    chmod +x ~/script/uninstaller/uninstaller.sh
    ```

4.  **Installez les dépendances nécessaires :**
    Le script utilise `whiptail` pour son interface TUI. Si vous utilisez `snap` ou `flatpak`, assurez-vous qu'ils sont également installés.

    * **Pour `whiptail` (essentiel) :**
        ```bash
        sudo apt update
        sudo apt install whiptail
        ```
    * **Pour `flatpak` (si vous comptez désinstaller des Flatpaks) :**
        ```bash
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub [https://flathub.org/repo/flathub.flatpakrepo](https://flathub.org/repo/flathub.flatpakrepo)
        # Redémarrez votre session ou votre PC après l'installation de flatpak
        ```
    * `snap` est généralement préinstallé sur Ubuntu.

5.  **Installez le lanceur d'application (optionnel, mais recommandé) :**
    Ceci ajoutera le "Désinstallateur Intelligent" à votre menu d'applications avec une icône.

    * **Copiez le fichier `.desktop` à l'emplacement approprié :**
        ```bash
        mkdir -p ~/.local/share/applications/
        cp ~/script/uninstaller/uninstaller.desktop ~/.local/share/applications/
        ```
    * **Mettez à jour les chemins dans le fichier `.desktop` :**
        Ouvrez le fichier `~/.local/share/applications/uninstaller.desktop` avec un éditeur de texte et assurez-vous que les chemins `Exec=` et `Icon=` sont corrects pour votre système. Ils devraient pointer vers l'emplacement où vous avez placé `uninstaller.sh` et `uninstaller_ico.png`.
        ```desktop
        [Desktop Entry]
        Name=Désinstallateur Intelligent
        Comment=Un outil graphique pour désinstaller des logiciels (apt, snap, flatpak)
        Exec=/home/VOTRE_NOM_UTILISATEUR/script/uninstaller/uninstaller.sh
        Icon=/home/VOTRE_NOM_UTILISATEUR/script/uninstaller/uninstaller_ico.png
        Terminal=true
        Type=Application
        Categories=System;Utility;
        Keywords=uninstall;remove;apt;snap;flatpak;logiciel;outil;
        StartupNotify=true
        ```
        **N'oubliez pas de remplacer `VOTRE_NOM_UTILISATEUR` par votre nom d'utilisateur réel (ex: `mahery`).**

    * **Redémarrez votre session** (déconnexion/reconnexion) pour que l'icône apparaisse dans votre menu d'applications.

## 💡 Utilisation

1.  **Via le menu des applications :** Recherchez "Désinstallateur Intelligent" dans votre menu d'applications et cliquez dessus. Un terminal s'ouvrira avec l'interface `whiptail`.
2.  **Via le terminal :**
    ```bash
    ~/script/uninstaller/uninstaller.sh
    ```

Une fois lancé, le script vous guidera :
* Entrez le nom (ou une partie du nom) du logiciel à désinstaller.
* Si plusieurs correspondances sont trouvées, utilisez les flèches pour sélectionner le logiciel souhaité dans la liste `whiptail` et appuyez sur `Entrée`.
* Confirmez la désinstallation lorsque vous y êtes invité.
* Tapez `exit` à l'invite pour quitter le script.

## ⚠️ Notes Importantes

* Le script nécessite les privilèges `sudo` pour les opérations de désinstallation (`apt` et `snap`). Il vous demandera votre mot de passe lorsque nécessaire.
* Un avertissement `WARNING: apt does not have a stable CLI interface. Use with caution in scripts.` peut apparaître. Ceci est un avertissement général d'APT et n'indique pas un problème avec le script lui-même. Vous pouvez l'ignorer en toute sécurité.
* Si vous rencontrez des problèmes de dépendances avec `apt`, essayez de lancer `sudo apt install -f` et `sudo apt autoremove` manuellement.

## 🤝 Contribution

Les contributions sont les bienvenues ! Si vous avez des idées d'amélioration, des rapports de bugs ou des suggestions, n'hésitez pas à ouvrir une issue ou à soumettre une pull request sur le dépôt GitHub.

## 📄 Licence

Ce projet est sous licence [Mah'ery RAZAFIMANANTSOA, MIT License].
