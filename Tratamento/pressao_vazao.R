library(readxl)
library(tibble)
library(dplyr)

dataPath <- paste0(Sys.getenv("COMPESA"), "/Data/")
writePath <- paste0(Sys.getenv("COMPESA"), "/Data/Processed/")

vazao <- read_excel(paste0(dataPath, "D52 historico Vazao.xlsx"), sheet = "Plan1")
vazao$Value <- gsub(" L/s", "", vazao$Value)
vazao$Value <- as.numeric(gsub(",", ".", vazao$Value))

pc <- read_excel(paste0(dataPath, "PC D52 - Pinhal com Magina (1).xlsx"), sheet = "Worksheet")
pm <- read_excel(paste0(dataPath, "PM D52 - José Domingues (1).xlsx"), sheet = "Worksheet")

pc$`Data e hora` <- lubridate::as_datetime(pc$`Data e hora`, format = "%d/%m/%Y %H:%M:%S")
pm$`Data e hora` <- lubridate::as_datetime(pm$`Data e hora`, format = "%d/%m/%Y %H:%M:%S")

