
#install.packages('ggplot2','reshape')
require(ggplot2)
require(reshape)

# Original Data Sources
#http://epi.yale.edu/files/air_quality_0.xls
#http://api.worldbank.org/v2/en/indicator/sp.dyn.le00.in?downloadformat=csv
#Converted to CSV
#https://github.com/AppTrain/getting_and_cleaning_data/blob/master/air_quality_PM2.5.csv
#https://github.com/AppTrain/getting_and_cleaning_data/blob/master/life_expectancy.csv
# Read Local files
airq = read.csv("air_quality_PM2.5.csv",skip=4)
mortality= read.csv("life_expectancy.csv",skip=2)


#cor(mortality,airq)
# Delete unwanted columns
mortality$Country.Code = NULL
mortality$Indicator.Code = NULL
mortality$Indicator.Name = NULL
mortality$X2013 = NULL
mortality$X2014 = NULL
mortality$X = NULL
# Delete rows with NA values
mortality = mortality[complete.cases(mortality),]


#Create a valid index for a join 
mortality$country_id = apply(mortality,1,function(row) substr(gsub(" ","",tolower(row["Country.Name"])),1,13))  
airq$country_id = apply(airq,1,function(row) substr(gsub(" ","",tolower(row["Country"])),1,8))
mm = merge(airq,mortality,by="country_id")

# Check for a correlation in the most recent year
cor(mm[,"X2012.x"],mm[,"X2012.y"],use="pairwise.complete.obs") 

full_matrix = cor(mm[sapply(mm,is.numeric)],use="pairwise.complete.obs")
full_matrix = cor(mm[sapply(mm,is.numeric)],use="pairwise.complete.obs",method="spearman") 

print(head(full_matrix))

