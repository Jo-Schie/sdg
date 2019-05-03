#define textstyle
style_text <- "font-family: 'calibri'; font-size: 16pt"


# create the UI
ui <-fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage("SDG Locator",
             # Panel of database
             tabPanel("Explore the Data",
                      sidebarPanel(
                        useShinyjs(),
                        div(
                          id="form",
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
                                      value = c(2010, 2015))
                          ),
                        actionButton("reset", "Reset"),
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
                      mainPanel(width= 8,
                        
                        h2('About SDGlocator'),
                        br(),
                        div("The cooperative between Agence Francaise de Développement (AFD)
                          and Kreditanstalt für Wiederaufbau (KfW) is proud to present the protype of the SDGlocator. It targets to facilitate the 
                          monitoring of development projects 
                          in regard to the Sustainable Development Goals (SDG).", style= style_text ),
                        br(),
                        div("The SDGlocator identifies the datasets to assess SDG's or their proxies on project-scale. It is based on open satellite data
                            (MODIS, VIIRS, Landsat and Sentinel), crowdsourced data (OSM, ...), household surveys among others.  The SDGlocator does not
                            claim to provide a complete overview about all SGD-related geolocalised sources. Nevertheless, it encourages the user to add missing indicators via this",
                            a(href="https://docs.google.com/forms/d/e/1FAIpQLSdrsBRcXQZ1RXlfBXWT8CTDuKZ0-2jT9H_4RsO1p2qVCwnbnQ/viewform", "form."),
                            style= style_text),
                        br(),
                        h3('Contact'),
                        br(),
                        div("Feel free to get in ", a(href="mailto:info@gsdlocator.org", "contact"), "for:", style= style_text,
                        tags$ul(
                          tags$li("Questions regarding the usage of GSDlocator, or"),
                          tags$li("Anykind of feedback"),
                          style= style_text),
                        br(),
                        br(),
                        br(),
                        img(src = "logo_afd_kfw.png", height = 131, width = 384)
                        
                        )
                      )
             )
  )
)
