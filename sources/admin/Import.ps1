# Chemin du fichier ISBN
$cheminFichier = "data/definition/isbn.txt"
$cheminBookApiKey = "sources/admin/booksApi.key"
$cheminFichierBooks = "data/full/books.ndjson"

if (Test-Path $cheminBookApiKey) {
    # Charge la clé
    $apiKey = Get-Content $cheminBookApiKey
} else {
    Write-Host "File not found : $cheminBookApiKey"
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

    # Supprime le fichier books
    if (Test-Path $cheminFichierBooks) {
        Remove-Item $cheminFichierBooks
    }

    # Ouvrir le fichier de sortie JSON en écriture
    $fileStream = [System.IO.StreamWriter] $cheminFichierBooks

    # Parcourir chaque code ISBN
    foreach ($isbn in $codesISBN) {
        Write-Host "Chargement des informations pour ISBN : $isbn"
        $bookInfo = GetBookInfo $isbn
        if ($bookInfo) {
            if ($bookInfo) {
                # Convertir les informations du livre en JSON
                $jsonObject = @{
                    Title = $bookInfo.Title
                    Authors = $bookInfo.Authors
                    PublishedYear = $bookInfo.PublishedYear
                    Publisher = $bookInfo.Publisher
                } | ConvertTo-Json -Depth 100 -Compress
    
                # Écrire le JSON dans le fichier de sortie
                $fileStream.WriteLine($jsonObject)
            } else {
                Write-Host "No data found for ISBN : $isbn"
            }
        } else {
            Write-Host "No data found for ISBN : $isbn"
            Write-Host ""
        }
    }

    # Fermer le fichier de sortie JSON
    $fileStream.Close()
    Write-Host "Data written in file $cheminFichierBooks."

} else {
    Write-Host "File not found $cheminFichier"
}
