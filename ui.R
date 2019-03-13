# create the UI
ui <-fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage("SDG Locator",
             # Panel of database
             tabPanel("Explore the Data",
                      sidebarPanel(
                        selectInput("goal",
                                    "Goal",
                                    choices = c("any", levels(tb_sdg2$Goal)),
                                    selected = c("any")
                        ),
                        selectInput("target", 
                                    "Target:",
                                    choices = NULL),
                        selectInput("country", 
                                    "Country:",
                                    choices = c("any",sort(unique(tb_sdg2$Country))),
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
                          tabPanel(p(icon("table"), "List of Indicators"),
                                   h4('Datasets', align = "center"),
                                   dataTableOutput(outputId = "dTable")
                          ), # end of "Dataset" tab panel
                          tabPanel(p(icon("table"), "Selected Target"),
                                   h4('Details', align = "center"),
                                   dataTableOutput("longtable")
                          ) # end of "Visualize the Data" tab panel
                        ))
             ),
             # about panel
             tabPanel("About",
                      h4('Number of Sets by Year', align = "center")
                      
             )
  ) 
)
