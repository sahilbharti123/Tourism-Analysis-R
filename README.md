# International Tourism Data Analysis Report

## Overview
This project involved an in-depth analysis of international tourism data from the World Bank to uncover insights into tourism trends and performance of different countries. By manipulating and visualizing the data in R, I gained proficiency in data wrangling, analysis, and visualization.

## Data Sources
The data was sourced from the World Development Indicators dataset provided by the World Bank. It included information on international tourism metrics like number of arrivals, departures, tourism revenue, GDP, etc. for countries globally from 2009-2019.
https://databank.worldbank.org/source/world-development-indicators

## Data Wrangling
- Imported required packages like tidyverse, ggplot2, rnaturalearth.
- Loaded World Bank data into R and performed initial cleaning.
- Filtered and grouped data to focus on relevant countries and metrics for analysis.
- Reshaped data from wide to long format for time series visualizations.
- Joined data with geographic shapefiles for mapping.

## Analysis and Visualizations
### World Map of Top Tourist Destinations
Reveals the top 10 countries attracting the most tourists, highlighting France, the United States, and Spain as popular destinations. Unveils the intriguing question: What factors drive this popularity?


### GDP vs. Inbound Tourists Line Chart
Illuminates a correlation between a country's GDP and the number of inbound tourists, emphasizing that higher GDPs correlate with increased tourist numbers. 

### Bubble Chart of GDP, Inbound Tourists, and Revenue
Offers a comprehensive view of a country's tourism industry, depicting that high-GDP nations not only attract more tourists but also generate increased revenue from tourism.

### Faceted Line Chart of Outbound Tourists (2009-2019)
Tracks outbound tourism's growth, categorized by income level, revealing a trend where prosperous countries witness a surge in citizens traveling abroad, linking the nation's international tourism growth to economic success.

### Faceted Bar Chart of Regional Tourism Revenue

Compares regions' performance in terms of tourism revenue as a percentage of total income over time. Highlights Asia, Latin America, and the Caribbean with the highest growth, contrasting with North America and Europe experiencing slightly negative growth

## Key Skills Demonstrated

- Importing, cleaning, filtering, grouping, joining, and reshaping data with R
- Data manipulation using dplyr package
- Joining data sources for integrated analysis
- Creating static and interactive visualizations with ggplot2
- Producing maps and custom graphics to reveal insights
- Implementing analysis and models to answer research questions
- Communicating data narratives effectively through visualizations
