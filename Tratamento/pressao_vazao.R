library(readxl)
library(tibble)
library(dplyr)

dataPath <- paste0(Sys.getenv("COMPESA"), "/Data/")
writePath <- paste0(Sys.getenv("COMPESA"), "/Data/Processed/")

vazao <- read_excel(paste0(dataPath, "D52 historico Vazao.xlsx"), sheet = "Plan1")
vazao$Value <- gsub(" L/s", "", vazao$Value)
vazao$Value <- as.numeric(gsub(",", ".", vazao$Value))
names(vazao)[names(vazao) == "Value"] <- "Vazao (L/s)"
#----------------temporario-----------------
vazao$`Time Stamp` <- lubridate::as_datetime(gsub("2020", "2021", vazao$`Time Stamp`), format = "%Y-%m-%d %H:%M:%S")
#-------------------------------------------
pc <- read_excel(paste0(dataPath, "PC D52 - Pinhal com Magina (1).xlsx"), sheet = "Worksheet")
pm <- read_excel(paste0(dataPath, "PM D52 - José Domingues (1).xlsx"), sheet = "Worksheet")

pc$`Data e hora` <- lubridate::as_datetime(pc$`Data e hora`, format = "%d/%m/%Y %H:%M:%S")
pm$`Data e hora` <- lubridate::as_datetime(pm$`Data e hora`, format = "%d/%m/%Y %H:%M:%S")

finalDf <- merge(pc, pm, by = "Data e hora", all = FALSE) %>% merge(vazao, by.x = "Data e hora", by.y = "Time Stamp", all = FALSE)

finalDf$Ano <- lubridate::year(finalDf$`Data e hora`)
finalDf$Mes <- lubridate::month(finalDf$`Data e hora`)
finalDf$Dia <- lubridate::day(finalDf$`Data e hora`)
finalDf$`Dia da Semana` <- lubridate::wday(finalDf$`Data e hora`)
diasNumero <- c(1, 2, 3, 4, 5, 6, 7)
diasNome <- c("Domingo", "Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado")
finalDf$`Dia da Semana` <- stringr::str_replace_all(finalDf$`Dia da Semana`, setNames(diasNome, diasNumero))
finalDf$Horario <- format(finalDf$`Data e hora`, format = "%H:%M:%S")

getTurn <- function(h){
  if((0 <= h) & (h < 6)){
    return("Madrugada")
  } else if((6 <= h) & (h < 12)){
    return("Manha")
  } else if((12 <= h) & (h < 18)){
    return("Tarde")
  } else if((18 <= h) & (h <= 23)){
    return("Noite")
  }
}

finalDf$Turno <- unlist(lapply(lubridate::hour(finalDf$`Data e hora`), getTurn))

finalDf$Estacao <- as.Date(paste0("2000", substr(lubridate::as_date(finalDf$`Data e hora`), 5, 10))) #ano 2000 para comparar apenas mes e ano

getStation <- function(data){
  if((as.Date("2000-03-21") <= data) & (data < as.Date("2000-06-21"))){
    return("Outono")
  } else if((as.Date("2000-06-21") <= data) & (data < as.Date("2000-09-23"))){
    return("Inverno")
  } else if((as.Date("2000-09-23") <= data) & (data < as.Date("2000-12-21"))){
    return("Primavera")
  } else if(((as.Date("2000-12-21") <= data) & (data < as.Date("2000-12-31"))) | ((as.Date("2000-01-01") <= data) & (data < as.Date("2000-03-21")))){
    return("Verao")
  }
}

finalDf$Estacao <- unlist(lapply(finalDf$Estacao, getStation))

data.table::fwrite(finalDf, file = paste0(writePath, "pressao_vazao.csv"))