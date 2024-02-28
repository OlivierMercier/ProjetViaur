# le fichier
viaur <- "ProjetViaur/data_viaur/viaur_donnees_brutes.xlsx"
file.exists(viaur)

# les feuilles
readxl::excel_sheets(viaur)

Coffrets <- readxl::read_xlsx(path = viaur,
                              sheet = "Coffrets")

synthese_vivarmor <- readxl::read_xlsx(path = chemin,
                                       sheet = "synthese")
# Exporter en Rdata :

save (viaur_donnees_brutes, file = "ProjetViaur/donnes_traitees_viaur")

