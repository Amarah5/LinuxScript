#!/bin/bash

show_message() {
    whiptail --title "Information" --msgbox "$1" 8 78
}

confirm_action() {
    whiptail --title "Confirmation" --yesno "$1" 8 78
}

echo "Outil de désinstallation intelligente"
echo "-------------------------------------"
show_message "Bienvenue dans l'outil de désinstallation intelligente. Il peut désinstaller des logiciels via apt, snap, et flatpak."

while true; do
    nom=$(whiptail --inputbox "Entrez le nom (ou une partie du nom) du logiciel à désinstaller (ou 'exit' pour quitter) :" 8 78 "" 3>&1 1>&2 2>&3)
    exitstatus=$?

    if [ $exitstatus -ne 0 ] || [[ "$nom" == "exit" ]]; then
        show_message "Fin du script. À bientôt, Mahery !"
        break
    fi

    if [[ -z "$nom" ]]; then
        show_message "Le nom ne peut pas être vide. Veuillez réessayer."
        continue
    fi

    declare -A correspondances_trouvees
    compteur=0
    menu_options=() 

    show_message "Recherche de '$nom'..."

    while IFS= read -r ligne; do
        paquet=$(echo "$ligne" | awk '{print $2}')
        if [[ -n "$paquet" && "$paquet" != "<none>" ]]; then
            compteur=$((compteur + 1))
            correspondances_trouvees[$compteur]="apt:$paquet"
            menu_options+=("$compteur" "apt: $paquet")
        fi
    done < <(dpkg -l | grep -i "$nom" | grep '^ii')

    while IFS= read -r ligne; do
        paquet=$(echo "$ligne" | awk '{print $1}')
        if [[ -n "$paquet" && "$paquet" != "Name" ]]; then
            compteur=$((compteur + 1))
            correspondances_trouvees[$compteur]="snap:$paquet"
            menu_options+=("$compteur" "snap: $paquet")
        fi
    done < <(snap list | grep -i "$nom")

    while IFS= read -r ligne; do
        full_id=$(echo "$ligne" | awk '{print $1}')
        if [[ -n "$full_id" && "$full_id" != "Application" && "$full_id" == *"$nom"* ]]; then
            compteur=$((compteur + 1))
            correspondances_trouvees[$compteur]="flatpak:$full_id"
            menu_options+=("$compteur" "flatpak: $full_id")
        fi
    done < <(flatpak list --app --columns=application | grep -i "$nom")


    if [ "$compteur" -eq 0 ]; then
        show_message "Aucun logiciel correspondant à '$nom' trouvé dans apt, snap ou flatpak."
    else
        choix_num=$(whiptail --title "Sélection du Logiciel" --menu "Choisissez le logiciel à désinstaller (utilisez les flèches, puis Entrée) :" 20 78 15 "${menu_options[@]}" 3>&1 1>&2 2>&3)
        exitstatus=$?

        if [ $exitstatus -ne 0 ]; then
            show_message "Opération annulée."
            continue 
        fi

        selection="${correspondances_trouvees[$choix_num]}"
        type=$(echo "$selection" | cut -d':' -f1)
        paquet_a_desinstaller=$(echo "$selection" | cut -d':' -f2-)

        if confirm_action "Vous avez sélectionné : $type: $paquet_a_desinstaller\n\nÊtes-vous sûr de vouloir désinstaller '$paquet_a_desinstaller' via $type ?"; then
            show_message "Désinstallation de '$paquet_a_desinstaller'..."
            case "$type" in
                apt)
                    sudo apt remove --purge -y "$paquet_a_desinstaller"
                    if [ $? -eq 0 ]; then
                        show_message "'$paquet_a_desinstaller' a été désinstallé avec succès via apt."
                    else
                        show_message "Erreur lors de la désinstallation de '$paquet_a_desinstaller' via apt.\nCode de sortie : $?"
                    fi
                    ;;
                snap)
                    sudo snap remove "$paquet_a_desinstaller"
                    if [ $? -eq 0 ]; then
                        show_message "'$paquet_a_desinstaller' a été désinstallé avec succès via snap."
                    else
                        show_message "Erreur lors de la désinstallation de '$paquet_a_desinstaller' via snap.\nCode de sortie : $?"
                    fi
                    ;;
                flatpak)
                    flatpak uninstall -y "$paquet_a_desinstaller"
                    if [ $? -eq 0 ]; then
                        show_message "'$paquet_a_desinstaller' a été désinstallé avec succès via flatpak."
                    else
                        show_message "Erreur lors de la désinstallation de '$paquet_a_desinstaller' via flatpak.\nCode de sortie : $?"
                    fi
                    ;;
                *)
                    show_message "Type de gestionnaire inconnu : $type"
                    ;;
            esac
        else
            show_message "Désinstallation annulée par l'utilisateur."
        fi
    fi

    show_message "Nettoyage des dépendances inutiles avec apt autoremove..."
    sudo apt autoremove -y > /dev/null
    show_message "Nettoyage terminé."

done