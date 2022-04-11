# Load libraries so they are available
library("shiny")
library(plotly)
library(tidyverse)
source("app_ui.R")
source("app_server.R")


# loaded `ui` and `server` variables
shinyApp(ui = ui, server = server)
