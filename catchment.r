###########################################################################################
#
# Datasource
sourceFileName <- 'catchment.csv'
#
kilometersColumnIndex = 1
altitudeColumnIndex = 2
# 
paramFirstColumnIndex = 3
# Leave NA to get the Column name from CSV
paramFirstDescription = "Forest"
paramFirstColor = "#5F9EA0"
# 
paramSecondColumnIndex = 4
# Leave NA to get the Column name from CSV
paramSecondDescription = "Grassland"
paramSecondColor = "#E1B378"
#
paramThirdColumnIndex = 5
# Leave NA to get the Column name from CSV
paramThirdDescription = "Agriculture"
paramThirdColor = "#FF0000"
#
paramFourthColumnIndex = 6
# Leave NA to get the Column name from CSV
paramFourthDescription = "Urban"
paramFourthColor = "#00FF00"
#
plotTitle = "Erlauf landuse"
xAxisTitle = "Kilometers from spring"
yAxisTitle = "Percentage [%]"
###########################################################################################
library(ggplot2)
library(plyr)

convertToDataFrame <- function(kilometers, values, type) {
  a <- cbind.data.frame(km = kilometers, percentage = values, type = type)
  return(a)
}

plotSamplingPoints <- function(sourceFileName, kilometersColumnIndex, samplingNameColumnIndex, xAxisMin, xAxisMax) {
  df <- read.csv(sourceFileName, header = TRUE, sep = ";", dec=",", check.names=FALSE)
  if (missing(xAxisMin)) {
    xAxisMin = min(df[,kilometersColumnIndex], na.rm=TRUE)
  }
  if (missing(xAxisMax)) {
    xAxisMax = max(df[,kilometersColumnIndex], na.rm=TRUE)
  }
  d <- cbind.data.frame(km = df[,kilometersColumnIndex], name = df[,samplingNameColumnIndex], value = 0)
  # remove non existing values
  d[d==""] <- NA
  d <- d[complete.cases(d), ]
  
  p <- ggplot()
  p <- p + geom_point(data=d, aes(x = km, y = value, colour="red"), shape=3, size=3)
  p <- p + geom_text(data=d, aes(x = km, y = value, label=name, angle=90), hjust=-0.7, vjust=0.5, size=5)
  p <- p + scale_x_continuous(limits=c(xAxisMin,xAxisMax), expand = c(0, 0))
  p <- p + scale_y_continuous(limits=c(0, 0.1), expand = c(0, 0))
  
  return(p)
}

plotLandUse <- function(sourceFileName, kilometersColumnIndex, altitudeColumnIndex,
                        plotTitle, xAxisTitle, yAxisTitle, xAxisMin, xAxisMax,
                        paramFirstColumnIndex, paramFirstDescription, paramFirstColor,
                        paramSecondColumnIndex, paramSecondDescription, paramSecondColor,
                        paramThirdColumnIndex, paramThirdDescription, paramThirdColor,
                        paramFourthColumnIndex, paramFourthDescription, paramFourthColor) {
  df <- read.csv(sourceFileName, header = TRUE, sep = ";", dec=",", check.names=FALSE)
  
  if (missing(paramFirstDescription)) {
    paramFirstDescription = names(df)[paramFirstColumnIndex]
  }
  if (missing(paramSecondDescription)) {
    paramSecondDescription = names(df)[paramSecondColumnIndex]
  }
  if (missing(paramThirdDescription)) {
    paramThirdDescription = names(df)[paramThirdColumnIndex]
  }
  if (missing(paramFourthDescription)) {
    paramFourthDescription = names(df)[paramFourthColumnIndex]
  }
  if (missing(xAxisMin)) {
    xAxisMin = min(df[,kilometersColumnIndex], na.rm=TRUE)
  }
  if (missing(xAxisMax)) {
    xAxisMax = max(df[,kilometersColumnIndex], na.rm=TRUE)
  }
  
  maxKilometers = max(df[,kilometersColumnIndex])
  
  paramFirstData <- convertToDataFrame(df[,kilometersColumnIndex], df[,paramFirstColumnIndex], paramFirstDescription)
  paramSecondData <- convertToDataFrame(df[,kilometersColumnIndex], df[,paramSecondColumnIndex], paramSecondDescription)
  paramThirdData <- convertToDataFrame(df[,kilometersColumnIndex], df[,paramThirdColumnIndex], paramThirdDescription)
  paramFourthData <- convertToDataFrame(df[,kilometersColumnIndex], df[,paramFourthColumnIndex], paramFourthDescription)
  
  plotData <- rbind.data.frame(paramFirstData, paramSecondData, paramThirdData, paramFourthData)

  p2 <- ggplot()
  p2 <- p2 + geom_area(aes(y = percentage, x = km, fill = type), data = plotData, stat="identity", position="stack")
  p2 <- p2 + ggtitle(plotTitle) + labs(x=xAxisTitle, y=yAxisTitle)
  # remove whitespace between plot and axis
  p2 <- p2 + scale_x_continuous(breaks = seq(xAxisMin,xAxisMax, 10), limits=c(xAxisMin,xAxisMax), expand = c(0, 0))
  p2 <- p2 + scale_y_continuous(expand = c(0, 0))
  p2 <- p2 + scale_fill_manual(values=c(paramFirstColor, paramSecondColor, paramThirdColor, paramFourthColor))
  
  return(p2)
}
