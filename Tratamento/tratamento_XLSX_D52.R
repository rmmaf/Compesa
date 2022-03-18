library(readxl)
library(tibble)
library(dplyr)
dataPath <- paste0(Sys.getenv("COMPESA"), "/Data/")
writePath <- paste0(Sys.getenv("COMPESA"), "/Data/Processed/")

process_D52 <- function(input, output){
  sheetPath <- paste0(dataPath, input)
  sheets <- excel_sheets(sheetPath)
  
  finalDf <- NULL
  
  for (s in sheets) {
    df <- read_excel(sheetPath, sheet = s, skip = 1)
    df <- add_column(.data = df, Periodo = rep(s, nrow(df)))
    finalDf <- bind_rows(finalDf, df)
  }
  
  write.csv(finalDf, paste0(writePath, output), row.names = FALSE)
}

process_D52("00407 - D52 - Aurelio de Castro - Pressão.xls", "00407 - D52 - Aurelio de Castro - Pressão.csv")
process_D52("00407 - D52 - Aurelio de Castro - Vazão.xls", "00407 - D52 - Aurelio de Castro - Vazão.csv")
process_D52("54975 - REC PC D52 - Pinhal com Magina - Pressão.xls", "54975 - REC PC D52 - Pinhal com Magina - Pressão.csv")
process_D52("64672 - REC PM D52 - José Domingues - Pressão.xls", "64672 - REC PM D52 - José Domingues - Pressão.csv")

# Dados do Distrito 52.xls

nos <- read_excel(paste0(dataPath, "Dados do Distrito 52.xls"), sheet = "Nós")
coords <- read_excel(paste0(dataPath, "Dados do Distrito 52.xls"), sheet = "Coordenadas")

finalDf <- merge(nos, coords, by.x = "ID", by.y = "Node", sort = FALSE)

write.csv(finalDf, paste0(writePath, "Distrito 52 - Nos e Coordenadas.csv"), row.names = FALSE)

trechos <- read_excel(paste0(dataPath, "Dados do Distrito 52.xls"), sheet = "Trechos")
write.csv(trechos, paste0(writePath, "Distrito 52 - Trechos.csv"), row.names = FALSE)

# Economias Distrito D-52.xls
auxDf <-  read_excel(paste0(dataPath, "Economias Distrito D-52.xls"), sheet = "features")
finalDf <- read_excel(paste0(dataPath, "Economias Distrito D-52.xls"), sheet = "features", n_max = nrow(auxDf) - 1)

write.csv(finalDf, paste0(writePath, "Economias Distrito D-52.csv"), row.names = FALSE)