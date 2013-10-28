#!/bin/sh
# Script permettant d'ajouter des flus à Akregator depuis Firefox
GROUP="Importation"
urls=${@/feed/http}
# Vérifions si Akregator fonctionne
if [ -z `pidof akregator` ]
then
	`akregator`
fi
for url in "$urls"; do
	qdbus org.kde.akregator /Akregator org.kde.akregator.part.addFeedsToGroup "$url" "$GROUP"
done
