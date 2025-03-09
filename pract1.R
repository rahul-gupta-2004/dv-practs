library("mongolite")

my_collection = mongo(collection = "Crime_prac", db = "TYIT_PRAC")

my_collection$count()

# 1. number of crimes that happend on street
my_collection$count('{"Location Description": "STREET"}')
head(my_collection$find('{"Location Description": "STREET"}'))

# 2. where do most crimes take place
my_collection$aggregate('[{
    "$group": {
        "_id": "$Location Description",
        "TotalCrimes": {"$sum": 1}
    }
}]')

library("dplyr")

# 3. display the location description and most crimes
data = my_collection$aggregate('[{
            "$group": {
                "_id": "$Location Description",
                "TotalCrimes": {"$sum": 1}
            }
        }]') %>%
        na.omit() %>%
        arrange(desc(TotalCrimes)) %>%
        head(10)

df = data.frame(data)

library("ggplot2")

ggplot(df, aes(x=X_id, y=TotalCrimes)) + geom_bar(stat="identity") + coord_flip()