# ui.R

shinyUI(fluidPage(
  
  titlePanel("Energy Use, Carbon Dioxide Emissions, and Quality of Life"), 
  
  sidebarLayout(
    
    sidebarPanel(
      
      helpText("People in different countries use different amounts of energy 
               and are responsible for greater or lesser amounts of greenhouse 
               gas emissions.  They also have different qualities of life, as 
               measured by GDP and life expectancy.  What do the relationships 
               between these variables look like?"),
      
      selectInput("y.var", 
                  label = "Y-axis variable",
                  choices = list("CO2 emissions per capita",
                                 "Per capita gross domestic product", 
                                 "Life expectancy"), 
                  selected = "CO2 emissions per capita"), 
      
      checkboxGroupInput("which.group", 
                         label = "Countries to highlight", 
                         choices = list("Top three emitters" = "big3", 
                                        "OPEC countries" = "opec", 
                                        "EU countries" = "eu")), 
      
      radioButtons("labels.yn", label = "Label highlighted countries?",
                   choices = list("Yes" = TRUE, "No" = FALSE), 
                   selected = TRUE)
      
    ),
    
    mainPanel(plotOutput("plot"), 
              
              br(), 
              
              textOutput("caption"), 
              
              hr(), 
              
              helpText(HTML("Shiny app by <a href = \"http://sites.psu.edu/papplegate/\">Patrick J. Applegate</a>.  Based on Chapter 2 of Wolfson, R. (2011, <em>Earth, Energy and Climate</em>, W. W. Norton and Company, 435 pp).  Data from the <a href = \"http://data.worldbank.org/\">World Bank</a>.  All data current for 2010.")))
    
  )
))