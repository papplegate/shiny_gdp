# server.R

require(shiny)
require(dplyr)
require(ggplot2)
require(ggrepel)

# Make a conversion factor to turn the energy-use-per-capita
# numbers into kW from kg oil equivalent.  
kg.oil2kW <- 4* 10^ 7/ 365/ 24/ 60/ 60/ 1000

# Make lists of countries that can be highlighted on the plot.  
big3 <- c("China", "United States", "India")
opec <- c("Iran, Islamic Rep.", "Iraq", "Kuwait", "Qatar", "Saudi Arabia", 
          "Venezuela, RB", "Indonesia", "Libya", "United Arab Emirates", 
          "Algeria", "Nigeria", "Ecuador", "Angola")
eu <- c("Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", 
        "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", 
        "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", 
        "Malta", "Netherlands", "Poland", "Portugal", "Romania", 
        "Slovak Republic", "Slovenia", "Spain", "Sweden", "United Kingdom")

# Read the data into memory.  All files come from 
# the World Bank data web site, http://data.worldbank.org/
# eg.pcap, per capita energy use in kg oil equivalent
# gdp.pcap, per capita GDP in US dollars
# life.ex, life expectancy at birth in years
# co2.pcap, per capita CO2 emissions in metric tons
eg.pcap <- select(read.csv("data/energy_use_per_capita.csv", skip = 4, 
                           header = TRUE), Country.Name, Country.Code, X2010)
co2.pcap <- select(read.csv("data/co2_emissions_per_capita.csv", skip = 4, 
                            header = TRUE), Country.Name, Country.Code, X2010)
gdp.pcap <- select(read.csv("data/gdp_per_capita.csv", skip = 4, 
                            header = TRUE), Country.Name, Country.Code, X2010)
life.ex <- select(read.csv("data/life_expectancy.csv", skip = 4, 
                           header = TRUE), Country.Name, Country.Code, X2010)

# Delete "countries" that are actually groups of countries
# based on geography, political affiliation, or economic
# similarities.  
non.countries <- read.csv("data/non_countries.csv", header = FALSE, 
                          colClasses = "character")$V1
eg.pcap <- eg.pcap[!(eg.pcap$Country.Name %in% non.countries), ]
co2.pcap <- co2.pcap[!(co2.pcap$Country.Name %in% non.countries), ]
gdp.pcap <- gdp.pcap[!(gdp.pcap$Country.Name %in% non.countries), ]
life.ex <- life.ex[!(life.ex$Country.Name %in% non.countries), ]

# Convert the energy use values into kW/person.  
eg.pcap <- mutate(eg.pcap, X2010 = X2010* kg.oil2kW)

# Set some axis labels.  
x.label <- "Primary energy use per capita (kW/person)"
y.labels <- c("CO2 emissions per capita (t/person-yr)",
              "Per capita gross domestic product (US $/person-yr)", 
              "Life expectancy (yr)")

shinyServer(
  function(input, output) {
    output$plot <- renderPlot({
      
      y.data <- switch(input$y.var, 
                       "CO2 emissions per capita" = co2.pcap,
                       "Per capita gross domestic product" = gdp.pcap,
                       "Life expectancy" = life.ex)
      
      y.label <- switch(input$y.var, 
                        "CO2 emissions per capita" = y.labels[1],
                        "Per capita gross domestic product" = y.labels[2],
                        "Life expectancy" = y.labels[3])
      
      all.data <- inner_join(select(eg.pcap, Country.Name, Country.Code, X2010), 
                             select(y.data, Country.Name, Country.Code, X2010), 
                             by = c("Country.Name", "Country.Code"))
      
      # Set up the plot.  
      p <- ggplot()+ 
        theme_bw()+ 
        theme(axis.title = element_text(size = rel(1.2)), 
              axis.text = element_text(size = rel(1.2)))+ 
        xlab(x.label)+ 
        ylab(y.label)
      
      # If none of the country groups have been selected, 
      if (is.null(input$which.group)) {
        
        # Add black points to the plot.  
        p <- p+ 
          geom_point(mapping = aes(X2010.x, X2010.y), data = all.data, 
                     color = "black")
      
      # If one or more of the country groups have been selected, 
      } else {
        
        # Add gray points to the plot.  
        p <- p+ 
          geom_point(mapping = aes(X2010.x, X2010.y), data = all.data, 
                     color = "gray")
        
        # Subset all.data and put the result in group.data.  
        for (i in 1: length(input$which.group)) {
          eval(parse(text = paste("group.data <- filter(all.data, Country.Name %in% ", 
                                  input$which.group[i], ")", sep = "")))
          
          # Pick a color for the new points based on which
          # country group is being handled.  
          color <- switch(input$which.group[i], 
                          "big3" = "red", 
                          "opec" = "blue", 
                          "eu" = "green")
          
          # Add the points for the country group in
          # question to the plot.  
          p <- p+ 
            geom_point(mapping = aes(X2010.x, X2010.y), data = group.data, 
                       color = color)
          
          if (input$labels.yn) {
            p <- p+ 
            geom_text_repel(mapping = aes(X2010.x, X2010.y, label = Country.Name), 
                            data = group.data, color = color, 
                            segment.color = color)
          }
        }
      }
      
      # Finally, draw the plot.  
      print(p)
      
    })
   
    output$caption <- renderText({switch(input$y.var, 
                                         "CO2 emissions per capita" = 
                                           "Carbon dioxide emissions per person generally increase as energy use per person rises.  People in some countries emit less carbon dioxide than people in other countries, even though they may use similar amounts of energy.",
                                         "Per capita gross domestic product" = 
                                           "Economic productivity per person generally increases as energy use per person rises, but some countries produce much more economic activity for their energy use than others.",
                                         "Life expectancy" = 
                                           "Life expectancy is a common measure of quality of life (Wolfson, 2011).  Life expectancy rises as energy use per person increases, but levels off above 3-5 kW/person.  People in certain countries live longer than in some others, even though they consume less energy.")
    })
    
  }
)