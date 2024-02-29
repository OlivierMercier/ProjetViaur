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

#convertir minuscule en majuscule
detection <- detection %>% 
  mutate(Marque=str_to_upper(Marque)) %>% 
  rename(Code=Marque)


#jointure entre 2 colonnes et 2 feuilles 
identification <- detection %>% 
  left_join(y=marquage) %>% 
  filter(!is.na(Espèce))

#nombre de poissons différents détectés sur au moins 1 des 3 antennes
n_poissons_detectes<- n_distinct(identification$Code)

id_poissons_detectes<- identification %>% 
  select(Code, Espèce) %>% 
  distinct()

library(tidyverse)
getwd()
load(file = "./viaur.RData")

#jointure entre 2 colonnes et 2 feuilles 
id_poi_amont <- detection %>% 
  left_join(y=marquage) %>% 
  filter(!is.na(Espèce))

#nombre de poissons différents détectés sur l'antenne 3
n_poissons_detectes_ant3<- id_poi_amont %>% 
  filter(Lecteur=="AMONT") %>% 
  select(Code, Espèce) %>% 
  distinct()

#parcours de tous les poissons détectés triés par code


#jointure entre poissons de l'antenne 3 et toues les détection

tri_poissons_code<- arrange(identification, Code)

#faire un graphique de déplacement par poisson
library(ggplot2)
code_ant3 <- n_poissons_detectes_ant3<- id_poi_amont %>% 
  filter(Lecteur=="AMONT") %>% 
  select(Code) %>% 
  distinct()



ggplot(data = tri_poissons_code) +
    geom_line(aes(x = Temps, y = Lecteur )) +
    facet_wrap(vars (code_ant3))

  