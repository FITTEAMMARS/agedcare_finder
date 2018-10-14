library(highcharter)
library(tidyverse)

# creates a JavaScript object

hcch <- function (hc_opts = list(), theme = getOption("highcharter.theme"), 
                  type = "chart", width = NULL, height = NULL, elementId = NULL) 
{
    assertthat::assert_that(type %in% c("chart", "stock", "map"))
    opts <- .join_hc_opts()
    if (identical(hc_opts, list())) 
        hc_opts <- opts$chart
    unfonts <- unique(c(.hc_get_fonts(hc_opts), .hc_get_fonts(theme)))
    opts$chart <- NULL
    x <- list(hc_opts = hc_opts, theme = theme, conf_opts = opts, 
              type = type, fonts = unfonts, debug = getOption("highcharter.debug"))
    attr(x, "TOJSON_ARGS") <- list(pretty = getOption("highcharter.debug"))
    htmlwidgets::createWidget(name = "highchart", x, width = width, 
                              height = height, package = "highcharter", elementId = elementId, 
                              sizingPolicy = htmlwidgets::sizingPolicy(defaultWidth = "100%", 
                                                                       knitr.figure = FALSE, knitr.defaultWidth = "100%", 
                                                                       browser.fill = TRUE))
}

    
year <- c(2007:2017)
workers <- c(82500,
             86000,
             108700,
             114400,
             112800,
             117300,
             128400,
             131200,
             145300,
             157200,
             163700)

tdata <- data.frame(year, workers)

tfit <- lm(workers ~ year, data = tdata)
new_val <- data.frame(year=c(2018,2019,2020,2021))
predict(tfit, new_val)


bar_h <- highchart() %>%
    hc_chart(type = "column") %>%
    hc_title(text = "Aged and Disabled Care Employment Outlook") %>%
    hc_xAxis(categories = tdata$year) %>%
    hc_add_series(data = tdata$workers,
                  name = "Number of Workers") %>%
    hc_add_theme(hc_theme_538())
bar_h

state <- c("NSW", "VIC", "QLD", "SA", "WA", "TAS", "NT", "ACT")
aged_avg <- c(26.4,
              25.1,
              20.3,
              12.1,
              10.8,
              3.5,
              0.8,
              1.8)
state_avg <- c(31.6,
             26.2,
             19.7,
             6.7,
             10.8,
             2.0,
             1.1,
             1.8)
state_data <- data.frame(state, aged_avg, state_avg)



write.csv(x = tdata, file = "./data/outlook.csv", row.names = FALSE)
write.csv(x = state_data, file = "./data/state_employment.csv", row.names = FALSE)

#htmlwidgets::createWidget("bar_test", x = bar_h, width = "100%", height = "100%")
