# Admin

## Présentation

Contient les outils d'administration de la liste des livres.

Import.ps1 est un script qui transforme le fichier data\definition\isbn.txt en data\full\books.json.

## Prérequis

- Activer un compte Google sur Google Developer et se rendre sur https://console.cloud.google.com
- Créer un projet
- Créer clé d'API dans le projet et la stocker dans le fichier booksApi.key dans le dossier courant
- Activer l'API Google Books sur la clé