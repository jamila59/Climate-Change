library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

server <- function(input, output) {

  # climate data
  climate_data <- read.csv("data/owid-co2-data.csv")

  # Introduction page Stats ---------------------------------------------------
  latest <- climate_data %>%
    filter(year == max(year)) %>%
    select(country) %>%
    pull(country)

  # country w/ lowest CO2 emission year 2019
  output$lowest_co2_2019 <- renderText({
    lowest_co2_2019 <- climate_data %>%
      filter(year == 2019) %>%
      filter(co2 == min(co2)) %>%
      pull(country)
    paste(
      "- In the year 2019 the country with the least co2 emissions was:",
      (lowest_co2_2019)
    )
  })

  # country w/ highest CO2 emission year 2019
  output$highest_co2_2019 <- renderText({
    highest_co2_2019 <- climate_data %>%
      filter(country != "World" & country != "Asia" & year == 2019) %>%
      filter(co2 == max(co2)) %>%
      pull(country)
    paste(
      "- In the year 2019 the country with the highest co2 emissions was:",
      (highest_co2_2019)
    )
  })

  # (2 summary stat in 1)
  # country w/ highest cumulative emissions 1751 through to 2019
  # plus the amout of co2 produced by country
  output$highest_cum_co2 <- renderText({
    highest_cum_co2 <- climate_data %>%
      filter(year == max(year)) %>%
      filter(country != "International transport" & country != "Europe" &
        country != "World" & country != "Asia" &
        country != "North America") %>%
      filter(cumulative_co2 == max(cumulative_co2)) %>%
      select(country, cumulative_co2)
    paste(
      "- The country with the highest cumulative emissions of CO2 from 1751
        through to 2019 was:", (highest_cum_co2$country),
      "producing", (highest_cum_co2$cumulative_co2), "Mt of CO2"
    )
  })

  # aggregate table of top 10 countries w/highest cumulative emissions globally
  # from the year 1751 to 2019
  output$top_10 <- renderTable({
    top_10 <- climate_data %>%
      filter(year == max(year)) %>%
      filter(country != "South America" & country != "Asia" &
        country != "International transport" & country != "Europe" &
        country != "North America" & country != "EU-28" &
        country != "Europe (excl. EU-27)" & country != "Africa" &
        country != "Asia (excl. China & India)" & country != "EU-27" &
        country != "Europe (excl. EU-28)" &
        country != "North America (excl. USA)" & country != "World") %>%
      top_n(10, wt = share_global_cumulative_co2) %>%
      arrange(-share_global_cumulative_co2) %>%
      select(country, year, share_global_cumulative_co2)
    top_10
  })

  # Widget-------------------------------------------------------------

  ## climate data narrowed down to co2 type and summary info
  co2_source <- climate_data %>%
    select(
      year, co2, cement_co2, coal_co2, flaring_co2, gas_co2, oil_co2,
      cumulative_co2
    ) %>%
    rename(
      cement = cement_co2, coal = coal_co2, flaring = flaring_co2,
      oil = oil_co2, gas = gas_co2, cumulative = cumulative_co2,
      Year = year
    )

  # intercative line plot
  output$line <- renderPlotly({
    my_plot <- ggplot(data = co2_source) +
      geom_line(
        mapping = aes_string(x = "Year", y = input$co2_type),
        color = input$color
      ) + 
      labs(
        title = "Year vs Source of CO2 Emissions",
        y = "CO2 (Mt)"
      )
    ggplotly(my_plot)
  })
}
