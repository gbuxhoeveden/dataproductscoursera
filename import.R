rail<-read.csv2("rail.csv", stringsAsFactors=FALSE)
rail$Date.of.occurrence <- as.Date(rail$Date.of.occurrence, format="%d/%m/%Y")
rail$year <- as.integer(strftime(rail$Date.of.occurrence,"%Y"))