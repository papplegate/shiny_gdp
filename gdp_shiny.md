Energy Use, Carbon Dioxide Emissions, and Quality of Life
========================================================
author: Patrick J. Applegate, http://sites.psu.edu/papplegate/
date: 20 April 2016
font-family: 'Helvetica'

Energy use and carbon dioxide emissions: short-term benefits, long-term consequences
========================================================

- [Most energy](https://www.iea.org/publications/freepublications/publication/KeyWorld_Statistics_2015.pdf) worldwide is produced by burning fossil fuels.  
- This energy allows people in industrialized countries to enjoy very high standards of living.  
- However, global mean surface air temperatures [will probably go up](http://www.ipcc.ch/pdf/assessment-report/ar5/wg1/WG1AR5_SPM_FINAL.pdf) as a result of fossil fuel use.  
- These temperature increases may have [important negative consequences](https://ipcc-wg2.gov/AR5/images/uploads/WG2AR5_SPM_FINAL.pdf) for future generations.  

Shiny app
========================================================

Here, I describe a simple [Shiny app](http://shiny.rstudio.com) that lets users explore the relationship between per capita energy use (plotted on the $x$-axis) and several other variables (plotted on the $y$-axis): 

1. per capita CO$_2$ emissions
2. per capita gross domestic product
3. life expectancy

Users can choose which variable to plot on the $y$-axis, as well as which of various country groups to highlight on the plot.  

The app is available online at https://papplegate.shinyapps.io/energy_co2_quality_of_life/

A sample plot
========================================================

![plot of chunk unnamed-chunk-1](gdp_shiny-figure/unnamed-chunk-1-1.png) 

References and useful links
========================================================

- Wolfson, R., 2011.  Energy, Environment, and Climate (2nd ed).  W. W. Norton and Company, 435 pp.  http://books.wwnorton.com/books/webad.aspx?id=23579
- International Energy Agency, 2015. Key World Energy Statistics.  Available online at https://www.iea.org/publications/freepublications/publication/KeyWorld_Statistics_2015.pdf
- Intergovernmental Panel on Climate Change Working Group 1, 2013.  Summary for Policymakers.  Available online at http://www.ipcc.ch/pdf/assessment-report/ar5/wg1/WG1AR5_SPM_FINAL.pdf
- Intergovernmental Panel on Climate Change Working Group 2, 2014.  Summary for Policymakers.  Available online at https://ipcc-wg2.gov/AR5/images/uploads/WG2AR5_SPM_FINAL.pdf
- World Bank data site, http://data.worldbank.org/
