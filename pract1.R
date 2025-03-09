# 14-12-24

# Load the mongolite package
library("mongolite")

# Connect to the MongoDB collection
my_collection = mongo(collection = "Crime", db = "TYIT2024")

# Count the total number of documents in the collection
my_collection$count()

# Q.1. Number of Crimes that happened on street
my_collection$count('{"Location Description":"STREET"}')
# Retrieve the documents where the location is street
my_collection$find('{"Location Description":"STREET"}')

# Q.2. Where do most crimes take place
my_collection$aggregate('[{
    "$group": {
        "_id":"Location Description",
        "TotalCrimes":{ "$sum":1 }
    }
}]')

# Load the dplyr package for data manipulation
library("dplyr")

# Display list of location description and most crimes
data = my_collection$aggregate('[{
        "$group": {
            "_id":"$Location Description",
            "TotalCrimes":{ "$sum":1 }
        }
    }]') %>% na.omit() %>% arrange(desc(TotalCrimes)) %>% head(10)

# Convert the data to a data frame for plotting
df = data.frame(data)

# Load the ggplot2 package for plotting
library("ggplot2")

# Create a simple bar plot
ggplot(df, aes(x = X_id, y = TotalCrimes)) + geom_bar(stat="identity") + coord_flip()

# Create a bar plot with specific fill color
ggplot(df, aes(x = X_id, y = TotalCrimes, fill="Spec")) +
    geom_bar(stat = "identity") +
    geom_text(aes(label=TotalCrimes)) + xlab("Location Desctiption") + ylab("Total Crimes") +
    coord_flip()

# Create a bar plot with different colors and sorted data
ggplot(df, aes(x = reorder(X_id, TotalCrimes), y = TotalCrimes, fill = X_id)) + 
    geom_bar(stat = "identity") + 
    geom_text(aes(label = TotalCrimes)) + 
    xlab("Location Description") + ylab("Total Crimes") + coord_flip() + 
    theme_minimal() + theme(legend.position = "none")

# Create a bar plot with minimal theme
ggplot(df, aes(x = reorder(X_id, TotalCrimes), y = TotalCrimes, fill = X_id)) + 
    geom_bar(stat = "identity") + 
    geom_text(aes(label = TotalCrimes)) + 
    xlab("Location Description") + ylab("Total Crimes") + coord_flip() + theme_minimal()