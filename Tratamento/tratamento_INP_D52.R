library(epanetReader)

pathInp <- paste0(Sys.getenv("COMPESA"), "/Data/D-52.inp")
writePath <- paste0(Sys.getenv("COMPESA"), "/Data/Processed/")

df <- epanetReader::read.inp(pathInp)

write.csv(df$Junctions, paste0(writePath, "D52_Junctions_inp.csv"), row.names = FALSE)
write.csv(df$Pipes, paste0(writePath, "D52_Pipes_inp.csv"), row.names = FALSE)
write.csv(df$Coordinates, paste0(writePath, "D52_Coordinates_inp.csv"), row.names = FALSE)