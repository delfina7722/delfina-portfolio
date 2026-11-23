#Delfina Grozdanoska
#IDS 400, Final Project

install.packages("dplyr")
install.packages("ggplot2")
install.packages("lubridate")

library(dplyr)
library(ggplot2)
library(lubridate)

setwd("C:/Users/delgr/Downloads/archive")
getwd()
list.files()
superstore <- read.csv("Sample - Superstore.csv", header = T)

colnames(superstore)
dim(superstore)
str(superstore)
summary(superstore)
colSums(is.na(superstore))

colnames(superstore) <- make.names(colnames(superstore))
colnames(superstore)
table(superstore$Category)
table(superstore$Sub.Category)
table(superstore$Segment)
table(superstore$Region)
table(superstore$Ship.Mode)

superstore$Category <- as.factor(superstore$Category)
superstore$Sub.Category <- as.factor(superstore$Sub.Category)
superstore$Segment <- as.factor(superstore$Segment)
superstore$Region <- as.factor(superstore$Region)
superstore$Ship.Mode <- as.factor(superstore$Ship.Mode)
superstore$Order.Date <- mdy(superstore$Order.Date)
superstore$Ship.Date <- mdy(superstore$Ship.Date)

str(superstore)
summary(superstore)

superstore_addedvars <- 
  superstore %>%
  mutate(profit_margin = Profit / Sales,
         order_year = year(Order.Date),
         order_month = month(Order.Date, label = T, abbr = T),
         order_quarter = quarter(Order.Date),
         shipping_days = as.numeric(Ship.Date - Order.Date),
         discount_level = case_when(
           Discount == 0 ~ "No Discount",
           Discount > 0 & Discount < 0.3 ~ "Low Discount",
           Discount >= 0.3 ~ "High Discount"
         ))

superstore_addedvars$discount_level <- as.factor(superstore_addedvars$discount_level)
str(superstore_addedvars)
summary(superstore_addedvars)

discount_analysis <- 
  superstore_addedvars %>%
  group_by(discount_level) %>%
  summarize(avg_sales = mean(Sales),
            avg_profit = mean(Profit),
            avg_profit_margin = mean(profit_margin),
            total_sales = sum(Sales),
            total_profit = sum(Profit),
            num_orders = n())
discount_analysis

ggplot(data = discount_analysis,
       mapping = aes(x = discount_level, y = avg_profit)) +
  geom_col(fill = "lightblue", color = "black") +
  ggtitle("Average Profit by Discount Level") +
  xlab("Discount Level") +
  ylab("Average Profit") +
  theme_light()

region_analysis <- 
  superstore_addedvars %>%
  group_by(Region) %>%
  summarize(total_sales = sum(Sales),
            total_profit = sum(Profit),
            avg_profit_margin = mean(profit_margin),
            num_orders = n()) %>%
  arrange(-total_profit)
region_analysis

ggplot(data = region_analysis,
       mapping = aes(x = reorder(Region, total_profit), y = total_profit)) +
  geom_col(fill = "lightblue", color = "black") +
  coord_flip() +
  ggtitle("Total Profit by Region") +
  xlab("Region") +
  ylab("Total Profit") +
  theme_light()

category_analysis <- 
  superstore_addedvars %>%
  group_by(Category) %>%
  summarize(total_sales = sum(Sales),
            total_profit = sum(Profit),
            avg_profit = mean(Profit),
            avg_profit_margin = mean(profit_margin),
            num_orders = n()) %>%
  arrange(-total_profit)
category_analysis

ggplot(data = category_analysis,
       mapping = aes(x = reorder(Category, total_profit), y = total_profit)) +
  geom_col(fill = "lightblue", color = "black") +
  coord_flip() +
  ggtitle("Total Profit by Product Category") +
  xlab("Product Category") +
  ylab("Total Profit") +
  theme_light()

sub_category_analysis <- 
  superstore_addedvars %>%
  group_by(Category, Sub.Category) %>%
  summarize(total_sales = sum(Sales),
            total_profit = sum(Profit),
            avg_discount = mean(Discount),
            avg_profit_margin = mean(profit_margin),
            num_orders = n()) %>%
  arrange(total_profit)
sub_category_analysis

ggplot(data = sub_category_analysis,
       mapping = aes(x = reorder(Sub.Category, total_profit), y = total_profit)) +
  geom_col(fill = "lightblue", color = "black") +
  coord_flip() +
  ggtitle("Total Profit by Sub-Category") +
  xlab("Sub-Category") +
  ylab("Total Profit") +
  theme_light()

save(superstore_addedvars, file = "superstore_cleaned.rda")