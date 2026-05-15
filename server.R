# create the server function
server<-function(input,output){
  mytable<-reactive({f_filter(min_year = input$timeline[1],
                              max_year = input$timeline[2],
                              input$country,
                              input$target)})
  output$dTable<-renderDataTable({mytable()})
  
  # Sources table: unique surveys with name, target(s), country count, year range, and access link
  output$sourcesTable <- renderDataTable({
    tb_sdg2 %>%
      group_by(Name, Access) %>%
      summarise(
        Targets    = paste(sort(unique(as.character(target))), collapse = "; "),
        Countries  = n_distinct(country),
        Start_Year = min(Start, na.rm = TRUE),
        End_Year   = max(End,   na.rm = TRUE),
        .groups    = "drop"
      ) %>%
      arrange(Name)
  }, escape = FALSE)
  
}