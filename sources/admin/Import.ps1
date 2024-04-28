# Chemin du fichier ISBN
$cheminFichier = "data/definition/isbn.txt"

# Vérifier si le fichier existe
if (Test-Path $cheminFichier) {
    # Charger les codes ISBN depuis le fichier
    $codesISBN = Get-Content $cheminFichier

    # Afficher les codes ISBN chargés
    Write-Host "Loaded ISBN codes :"
    foreach ($isbn in $codesISBN) {
        Write-Host $isbn
    }

    # Vous pouvez utiliser $codesISBN pour effectuer d'autres opérations
} else {
    Write-Host "Le fichier $cheminFichier n'existe pas."
}
