# ouverture de la librairie tidyverse
library(tidyverse)

# le fichier
viaur <- "data_viaur/viaur_donnees_brutes.xlsx"
file.exists (viaur)

# les feuilles
readxl::excel_sheets("data_viaur/viaur_donnees_brutes.xlsx")

detection <- readxl::read_xlsx(path = viaur,
                              sheet = "Coffrets")
marquage <- readxl::read_xlsx(path = viaur,
                               sheet = "Marquages")
mouchard <- readxl::read_xlsx(path = viaur,
                               sheet = "Mouchards")
hauteureau <- readxl::read_xlsx(path = viaur,
                               sheet = "HauteurEau")
temperature <- readxl::read_xlsx(path = viaur,
                               sheet = "Température")

# Exporter en Rdata :
save(viaur, file = "viaur.RData")

detection <- detection %>% 
  mutate(Marque=str_to_upper(Marque)) %>% 
  rename(Code=Marque)



identification <- detection %>% 
  left_join(y=marquage) %>% 
  filter(!is.na(Espèce))

n_poissons_detectes<- n_distinct(identification$Code)

id_poissons_detectes<- identification %>% 
  select(Code, Espèce) %>% 
  distinct()

