library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(lintr)
library(styler)

ui <- navbarPage(
  "Climate Change Analysis",
  tabPanel(
    titlePanel("Climate Data Insights"),
    sidebarLayout(
      sidebarPanel(
        h4("Summary Statistics")
      ),
      mainPanel(
        p(
          "This project is about Climate Change, below i have computed various
        summary statistics that introduce facts computed using",
          em("Out World in Data"), "dataset."
        ),
        p(textOutput(outputId = "lowest_co2_2019")),
        p(textOutput(outputId = "highest_co2_2019")),
        p(textOutput(outputId = "highest_cum_co2")),
        p(
          "- Below is a list of the top 10 contries which have contributed the
        greatest percentage of CO2 emissions globally from the year 1751
        through 2019",
          tableOutput(outputId = "top_10")
        )
      )
    )
  ),
  tabPanel(
    titlePanel("Emissions"),
    sidebarLayout(
      sidebarPanel(
        h3("Adjustable Parameters"),
        selectInput(
          inputId = "co2_type",
          label = "Choose a CO2 variable for your line chart",
          choices = c(
            "co2", "cement", "coal", "flaring", "gas",
            "oil", "cumulative"
          )
        ),
        color_input <- selectInput(
          inputId = "color",
          choices = c("red", "green", "purple"),
          label = "Choose a color"
        )
      ),

      ### Main panel displays the lineplot
      mainPanel(
        h3("Source of CO2 Emissions (1751 - 2019)"),
        plotlyOutput(outputId = "line"),
        p("The chart above provides insight to how different sources have
          contriburted to the emissions of CO2. One interesting pattern
          that emerges when studying this plot is that in the early 2000's coal
          had a sharp drop in contribution, but quickly regianed its
          contributions in the 2010's by almost doubling in CO2 emissions.")
      )
    )
  )
)
