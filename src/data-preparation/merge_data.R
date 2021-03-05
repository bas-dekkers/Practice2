# Load datasets into R 
df1 <- read.csv("./gen/data-preparation/input/dataset1.csv")
df2 <- read.csv("./gen/data-preparation/input/dataset2.csv")
df3 <- read.csv("./gen/data-preparation/input/listings.csv")
df4 <- read.csv("./gen/data-preparation/input/reviews.csv")

#transform column df4
colnames(df4) <- c("id", 
                   "date")

# Merge on id
df_merged <- merge(df1,df2, by="id")
df_merged_airbnb <- merge(df3, df4, by="id")

#df_merged <- df_merged_complete

# Save merged data
save(df_merged,file="./gen/data-preparation/temp/data_merged.RData")
save(df_merged_airbnb,file="./gen/data-preparation/temp/data_airbnb.RData")
write.csv(df_merged, "./gen/data-preparation/temp/df_merged.csv")
write.csv(df_merged_airbnb, "./gen/data-preparation/temp/df_merged_airbnb.csv")
