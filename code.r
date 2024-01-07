install.packages("tidyverse")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("tidyr")
install.packages("WDI")
install.packages("countrycode")
install.packages("viridis")
install.packages("ggthemes")
install.packages("rnaturalearth")

library(ggplot2)
library(tidyverse)
library(dplyr)
library(tidyr)
library(WDI)
library(countrycode)
library(viridis)
library(ggthemes)
library(rnaturalearth)

new_wdi_cache<- WDIcache()

#Creating an object with the required data

tourism<- WDI(country= "all",
              indicator = c("ST.INT.ARVL", "ST.INT.DPRT", "ST.INT.RCPT.XP.ZS", "NY.GDP.MKTP.CD", 
                            "ST.INT.RCPT.CD"),
              start=2009,
              end=2019,
              extra=TRUE,
              cache = new_wdi_cache)
view(tourism)

#Data cleaning for visualisation

tourism$ST.INT.ARVL<-tourism$ST.INT.ARVL/1000000
tourism$ST.INT.DPRT<-tourism$ST.INT.DPRT/1000000
tourism$NY.GDP.MKTP.CD<-tourism$NY.GDP.MKTP.CD/1000000
tourism$ST.INT.RCPT.CD<-tourism$ST.INT.RCPT.CD/1000000


filteredWDII<-tourism %>% 
  as_tibble() %>%
  mutate(region = countrycode(iso2c, "iso2c", "region")) %>% 
  filter(!region %in% c("Sub-Saharan Africa", "Middle East & North Africa"), 
         !is.na(region))

filteredWDI<-tourism %>% 
  as_tibble() %>%
  mutate(region = countrycode(iso2c, "iso3c", "region")) %>% 
  filter(is.na(region))

#Inbound Tourism

inbound_tourism<-filteredWDII %>% group_by(country) %>% summarise(value=sum(ST.INT.ARVL))

inbound_tourism<- inbound_tourism[order(inbound_tourism$value, decreasing = TRUE, na.last = TRUE),]
view(inbound_tourism)

inbound_tourism_topten<- inbound_tourism[1:10,]
view(inbound_tourism_topten)

inbound_data<-WDI(country= c("FR","US","CN","ES","MX","IT","PL","HR",
                             "HK", "HU"),
                  indicator = c("ST.INT.ARVL", "ST.INT.DPRT", "ST.INT.RCPT.XP.ZS", "NY.GDP.MKTP.CD", 
                                "ST.INT.RCPT.CD"),
                  start=2009,
                  end=2019,
                  extra=TRUE,
                  cache = new_wdi_cache)

inbound_data[is.na(inbound_data)] <- 0
inbound_data$ST.INT.ARVL<-inbound_data$ST.INT.ARVL/1000000
inbound_data$NY.GDP.MKTP.CD<-inbound_data$NY.GDP.MKTP.CD/1000000


#Outbound Tourism

outbound_tourism<-filteredWDII %>% group_by(country) %>% summarise(value=sum(ST.INT.DPRT))

outbound_tourism<- outbound_tourism[order(outbound_tourism$value, decreasing = TRUE, na.last = TRUE),]
view(outbound_tourism)

outbound_tourism_topten<- outbound_tourism[1:10,]
view(outbound_tourism_topten)

outbound_data<-WDI(country= c("US","DE","HK","GB","IT","CA","AR","KZ","TH","MX","AL","TR","ID","LK","NI"),
                   indicator = c("ST.INT.ARVL", "ST.INT.DPRT", "ST.INT.RCPT.XP.ZS", "NY.GDP.MKTP.CD", 
                                 "ST.INT.RCPT.CD"),
                   start=2009,
                   end=2019,
                   extra=TRUE,
                   cache = new_wdi_cache)

outbound_data[is.na(outbound_data)] <- 0
outbound_data$ST.INT.DPRT<-outbound_data$ST.INT.DPRT/1000000

#Visualisations

#1 world map showing the top 10 countries which attract the most tourists

inbound_tourists<-filteredWDI %>% group_by(country) %>% summarise(value=sum(ST.INT.ARVL))

inbound_tourists<- inbound_tourists[order(inbound_tourists$value, decreasing = TRUE, na.last = TRUE),]
view(inbound_tourism)

inbound_tourism_topten<- inbound_tourism[1:10,]
inbound_tourism_topnine<-inbound_tourism_topten %>% filter(inbound_tourism_topten$country != "Hong Kong SAR, China")

view(inbound_tourism_topten)


map <- ne_countries(scale = "medium", returnclass = "sf")
map<-map %>% filter(!admin=="Antarctica")
map_abc <- left_join(map, inbound_tourists, by = c("name_long" = "country"))
colnames(map_abc)[64]<-"Tourists"

map1<-left_join(inbound_tourism_topnine, map, by = c("country" = "name_long"))

ggplot(map_abc) +
  geom_sf(aes(fill = Tourists)) +
  ggtitle("Distribution of international tourists") +
  scale_fill_gradient(labels= c("0 Billion","0.5 Billion","1 Billion","1.5 Billion","2 Billion"),
                      low = "white", high = "blue")+
  coord_sf(datum = NA)+
  ggrepel::geom_label_repel(
    data = map1,
    aes(label= name, geometry=geometry),
    stat = "sf_coordinates",
    min.segment.length = 0,
    max.overlaps = 100
  )+
  labs(subtitle="Top Countries with most inbound tourists(from year 2009-2019)", x="",y="",caption = "Data Source: World Bank")+
  theme(plot.title = element_text(face = "bold"))


#2 line chart showing GDP vs the number of inbound tourists


ggplot(inbound_data,aes(x= year, y = ST.INT.ARVL, group = country, color=country))+

  scale_x_continuous(breaks = seq(2009,2019,1))+
  scale_fill_viridis(discrete = TRUE,guide = FALSE, option = "D")+
  geom_point(size=3,alpha=0.3)+
  theme_base()+
  geom_line(size= 1)+labs(title = "Inbound Tourism", 
                          subtitle = "Fluctuation in tourism numbers within the leading nations over a ten-year period",
                          x="Year(2009-2019)", y="Number of Inbound Tourists(in Millions)",
                          caption = "Data Source: World Bank")

#3 Bubble chart showing GDP, inbound tourists, and revenue generated from tourism

inbound_data[is.na(inbound_data)] <- 0
inbound_data_bubble<-inbound_data %>% filter(inbound_data$ST.INT.RCPT.CD != 0)
inbound_data_bubble$ST.INT.RCPT.CD<-inbound_data_bubble$ST.INT.RCPT.CD/1000000
inbound_data_bubble$NY.GDP.MKTP.CD<-inbound_data_bubble$NY.GDP.MKTP.CD/1000

ggplot(inbound_data_bubble, aes(x=NY.GDP.MKTP.CD, y=ST.INT.ARVL, size = ST.INT.RCPT.CD, color = country)) +
  geom_point(alpha=0.5) +
  theme_base()+
  ggtitle("Relationship between Tourism Revenue, Number of Tourists and GDP of the countries") +
  scale_x_continuous(trans = "log", breaks = c(160,1200,9000)) + 
  scale_y_continuous(trans = "log",breaks = c(40,60,80,100,120,140,160,180)) +
  scale_size(range=c(0.1,20),name="Revenue generated(in Millions)") + labs(x="GDP(in Billions)",y="Number of Inbound Tourists(in Millions)", 
                                                                           subtitle = "Exploring the Interplay of Tourism Revenue,Tourist Arrivals and GDP in Top Countries (the points represent years from 2009 to 2019)",
                                                                           caption = "Data Source: World Bank")


#4 faceted line chart showing the Number of outbound tourists over the period of 2009-2019, categorized by income level

ggplot(outbound_data, aes(x = year, y = ST.INT.DPRT, colour=country)) +
  scale_y_continuous(breaks = c(20,40,60,80,100,120,140,160,180))+
  scale_x_continuous(breaks = c(2009, 2011, 2013, 2015, 2017, 2019), 
                     labels = c("2009", "2011", "2013","2015","2017","2019"))+
  theme(axis.text.x = element_text(rel(2)))+
  geom_point(size=3,alpha=0.3)+
  theme_base()+
  geom_line(size= 1)+
  facet_grid(~fct_relevel(income,'Lower middle income', 'Upper middle income', 'High income'), scales = "free")+
  labs(title = "Trend of outbound tourism across income levels of countries over the years", 
       x = "Year(2009-2019)", y = "Number of outbound tourists(in Millions)", color = "Country",
       caption = "Data Source: World Bank")


#5 faceted bar chart shows the year vs receipts (% of export) grouped by region

bar<-filteredWDII[,c(1,4,12,17)]
bar<-na.omit(bar)

bar_facet<-bar %>% group_by(region,year) %>% summarise(value=mean(ST.INT.RCPT.XP.ZS))
bar_facet<- bar_facet %>% filter(year != "2019")

ggplot(bar_facet, aes(x = year, y = value, fill=region)) +
  scale_x_continuous(breaks = c(2009,2013,2017), 
                     labels = c("2009", "2013","2017"))+
  geom_point(size=1,alpha=0.3)+
  theme_base()+scale_fill_viridis_d()+
  geom_bar(position = "dodge", stat = "identity", color = "black")+
  facet_grid(. ~ region)+
  labs(title = "Trends in Tourism Income as a Percentage of overall income over the Years: A Regional Perspective", 
       x = "Year(2009-2018)", y = "Tourism Revenue as a Percentage of Total Revenue",
       caption = "Data Source: World Bank") +
  theme(legend.position = "none") + ylim(0,50)