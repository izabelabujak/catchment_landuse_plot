# Catchment/Landuse plot
R script to generate a plot showing land use contribution along the river

## Input data
Provide the profile of your catchment inside the catchment.csv file.
The landuse contribution you can calculate using ArcGIS from CORINE Land Cover data sets.

## Usage
In your script attach the catchment.R file and call the `plotLandUse` function.

example:
```
source("catchment.r")
plot <- plotLandUse('catchment.csv', kilometersColumnIndex=1, altitudeColumnIndex=2, 
                  xAxisMin=0, xAxisMax=64,
                  plotTitle="My River land use", xAxisTitle="Distance from spring [km]", yAxisTitle="Landcover type [%]",
                  paramFirstColumnIndex=4, paramFirstColor="#CDDC39", #forest
                  paramSecondColumnIndex=5, paramSecondColor="#FFEB3B", #grassland
                  paramThirdColumnIndex=6, paramThirdColor="#d35400", #agri
                  paramFourthColumnIndex=7, paramFourthColor="#6C7A89")
plot
```

## Contact
If you have any question, just contact me. I am always willing to help!

