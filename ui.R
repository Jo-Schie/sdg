# create the UI
ui <-fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage("SDG Locator",
             # Panel of database
             tabPanel("Explore the Data",
                      sidebarPanel(
                        selectInput("target", 
                                    "Target:",
                                    choices = c("any",sort(unique(sort(tb_sdg2$target)))),
                                    selected = c("any")),
                        selectInput("country", 
                                    "Country:",
                                    choices = c("any",sort(unique(tb_sdg2$country))),
                                    selected = c("any")),
                        sliderInput("timeline", 
                                    "Timeline:", 
                                    min = 1990,
                                    max = 2018,
                                    value = c(2010, 2015)),
                        uiOutput("themesControl")
                      ),
                      mainPanel(
                        tabsetPanel(
                          # Data 
                          tabPanel(p(icon("table"), "shortform"),
                                   h4('Datesets', align = "center"),
                                   dataTableOutput(outputId = "dTable")
                          ), # end of "Dataset" tab panel
                          tabPanel(p(icon("table"), "longform"),
                                   h4('Number of Sets by Year', align = "center")
                          ) # end of "Visualize the Data" tab panel
                        ))
                      ),
             # about panel
             tabPanel("About",
                      h4('Number of Sets by Year', align = "center")

             )
             ) 
)