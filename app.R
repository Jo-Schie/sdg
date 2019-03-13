# load libraries
library("tidyverse")
library("googledrive")
library("shiny")
library("shinythemes")
library("DT")

# download and preprocess the data
source("preprocessing.R")

# load the filter function
source("filter.R")

# create the ui
source("ui.R")

# create the server
source("server.R")

# create the app
shinyApp(ui=ui,server = server)
