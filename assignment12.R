library(knitr)
library(rmongodb)
library(devtools)
#install_github(repo = "mongosoup/rmongodb")


#### MongoDB section
#  the restaurants json file is found in the below link:
#  https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/dataset.json 
#
# for reference only: below is the extract of the json restaurants file. However, for the assignment we are importing the json file from 
# MongoDB 

# library("rjson")
# json_file <- "https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/dataset.json"
# json_data <- fromJSON(paste(readLines(json_file), collapse=""))
#
#
# Below is the command used to import the restaurants dataset from json file called dataset.json 
# C:\"Program Files"\MongoDB\Server\3.0\bin\mongoimport.exe -d local -c collection1  --file "c:\mongodb\dataset\dataset.json"
####




# Connecting R to MongoDB
mongo <- mongo.create()
# Check the connection
mongo.is.connected(mongo)


# Get all databases of the MongoDB connection:
if(mongo.is.connected(mongo) == TRUE) {
  mongo.get.databases(mongo)
}


#Get all collections in a specific database of your MongoDB (in this case, the "local" database)

if(mongo.is.connected(mongo) == TRUE) {
  db <- "local"
  mongo.get.database.collections(mongo, db)
  }

# Select collection1 from local database
restaurants <- "local.collection1"

# Collection1 has information about restaurants in NYC in all five boroughs 
# Below is a sample document in the restaurants collection:

##{
##  "address": {
##    "building": "1007",
##    "coord": [ -73.856077, 40.848447 ],
##    "street": "Morris Park Ave",
##    "zipcode": "10462"
##  },
##  "borough": "Bronx",
##  "cuisine": "Bakery",
##  "grades": [
## { "date": { "$date": 1393804800000 }, "grade": "A", "score": 2 },
## { "date": { "$date": 1378857600000 }, "grade": "A", "score": 6 },
## { "date": { "$date": 1358985600000 }, "grade": "A", "score": 10 },
## { "date": { "$date": 1322006400000 }, "grade": "A", "score": 9 },
## { "date": { "$date": 1299715200000 }, "grade": "B", "score": 14 }
## ],
## "name": "Morris Park Bake Shop",
## "restaurant_id": "30075445"
## }



# Using the command mongo.count, we can check how many documents are in the collection or in the result of a specific query.
# More information for all functions can be found in the help files.

if(mongo.is.connected(mongo) == TRUE) {
  help("mongo.count")
  mongo.count(mongo, restaurants)
}


# In order to run queries it is important to know some details about the available data. 
# First of all you can run the command mongo.find.one to get one document from your collection.

if(mongo.is.connected(mongo) == TRUE) {
  mongo.find.one(mongo, restaurants)
}


# The command mongo.distinct is going to provide a list of all values for a specific key in this case "borough".
# only two distinct borough : ("Bronx"         "Brooklyn"      "Manhattan"     "Queens"        "Staten Island" "Missing")

distinct_Boroughs<- if(mongo.is.connected(mongo) == TRUE) {
  res <- mongo.distinct(mongo, restaurants,  key= "borough")
  #head(res, 100)
}

data.frame("Distinct Boroughs"= distinct_Boroughs)


# Find the list of zipcodes in the restaurants collections
distinct_zipcodes<- if(mongo.is.connected(mongo) == TRUE) {
  res <- mongo.distinct(mongo, restaurants,  key= "address.zipcode")
  #head(res, 100)
}
data.frame("Zipcodes"= distinct_zipcodes)


######
# Find All grade "A" Pizza restaurants in Manhattan NYC

if(mongo.is.connected(mongo) == TRUE) {
  res <- mongo.find.all(mongo, coll, query = list(  
                                                  'cuisine' = "Pizza",
                                                  'borough' = "Manhattan",
                                                  'grades.grade' = "A"
                                                  ))
                                        }
# Select only the first document 
x<- head(res,1)
res_info<- data.frame(x)

#str(res_info)
#class(res_info)
# Reshape the data 
library(reshape)
md<- melt(res_info)

#md <- melt(res_info, address=(c("name", "address")))
res_md <- data.frame(md)
res_md 
