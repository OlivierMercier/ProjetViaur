# ouverture de la librairie tidyverse
library(tidyverse)
library(readxl)

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


#jointure entre poissons de l'antenne 3 et toutes les détection

tri_poissons_code<- arrange(identification, Code) %>% 
  mutate(Lecteur = as.factor(Lecteur), 
         Lecteur = fct_relevel(Lecteur, "RIVIERE", "AVAL" ,   "AMONT"  ))


#Nombre d'antenne(s) par poissons
n_ant_par_poisson<- tri_poissons_code %>% 
  group_by(Code) %>% 
  summarise(n_ant=n_distinct(Lecteur))

mes_poissons<-n_ant_par_poisson %>% 
  filter(n_ant ==3) %>% 
  pull (Code)


#faire un graphique individuel à partir d'un code
graphique_ind <-
ggplot(data = tri_poissons_code %>% 
         filter(Code == "8000E1349EAB9700") %>% 
         
         mutate(Lecteur = as.numeric(Lecteur))) +
  # OU mutate(Lecteur = case_when(
  #   Lecteur == "AMONT"~1,
  #   Lecteur == "AVAL"~2,
  #   Lecteur == "RIVIERE"~3,)
  aes(x = Temps, y = Lecteur )+
  geom_point() +
  geom_line()+
  scale_y_continuous(name="Lecteur", breaks = 1:3, labels = c("RIVIERE","AVAL", "AMONT"))
graphique_ind


#faire un graphique pour tous les codes
graphique_all <-
  ggplot(data = tri_poissons_code %>% 
           filter(Code %in% mes_poissons) %>% 
          mutate(Lecteur = as.numeric(Lecteur))) +
  aes(x = Temps, y = Lecteur )+
  geom_point() +
  geom_line() +
  facet_wrap(vars (Code)) +
  scale_y_continuous(name="Lecteur", breaks = 1:3, labels = c("RIVIERE","AVAL", "AMONT"))
graphique_all

save(graphique_all,n_poissons_detectes_ant3,
     file="analyse_viaur/figures_rmarkdown.rda")




