# Chemin du fichier ISBN
$cheminFichier = "data/definition/isbn.txt"
$cheminBookApiKey = "sources/admin/booksApi.key"

if (Test-Path $cheminBookApiKey) {
    # Charge la clé
    $apiKey = Get-Content $cheminBookApiKey
} else {
    Write-Host "Le fichier $cheminBookApiKey n'existe pas."
    Return
}

# Fonction pour interroger l'API Google Books pour obtenir les informations du livre par ISBN
function GetBookInfo($isbn) {
    $url = "https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&key=$apiKey"
    $response = Invoke-RestMethod -Uri $url -Method Get
    if ($response.totalItems -gt 0) {
        $bookInfo = $response.items[0].volumeInfo
        $title = $bookInfo.title
        $authors = $bookInfo.authors -join ", "
        $publishedYear = $bookInfo.publishedDate
        $publisher = $bookInfo.publisher
        return @{
            Title = $title
            Authors = $authors
            PublishedYear = $publishedYear
            Publisher = $publisher
        }
    } else {
        return $null
    }
}

# Vérifier si le fichier existe
if (Test-Path $cheminFichier) {
    # Charger les codes ISBN depuis le fichier
    $codesISBN = Get-Content $cheminFichier

    # Parcourir chaque code ISBN
    foreach ($isbn in $codesISBN) {
        Write-Host "Chargement des informations pour ISBN : $isbn"
        $bookInfo = GetBookInfo $isbn
        if ($bookInfo) {
            # Afficher les informations du livre
            Write-Host "Titre : $($bookInfo.Title)"
            Write-Host "Auteurs : $($bookInfo.Authors)"
            Write-Host "Année d'édition : $($bookInfo.PublishedYear)"
            Write-Host "Éditeur : $($bookInfo.Publisher)"
            Write-Host ""
        } else {
            Write-Host "Aucune information trouvée pour ISBN : $isbn"
            Write-Host ""
        }
    }
} else {
    Write-Host "Le fichier $cheminFichier n'existe pas."
}
