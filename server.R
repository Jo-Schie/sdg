# create the server function
server<-function(session, input,output){
  mytable<-reactive({f_filter(min_year = input$timeline[1],
                              max_year = input$timeline[2],
                              input$country,
                              input$target,
                              input$goal)})
  
  observe({
    x <- sort(as.character(tb_sdg2$Target[tb_sdg2$Goal == input$goal]))
    
    updateSelectInput(session, "target", "Target", choices = c("any",unique(x)))
  })

  #reset inputs to default
  observeEvent(input$reset, {
    reset("form")
  })
  
mylongtable <- reactive({f_filter_long(min_year = input$timeline[1],
                                  max_year = input$timeline[2],
                                  input$country,
                                  input$target,
                                  input$goal)})
  
  output$dTable<-DT::renderDataTable({mytable()}, escape = FALSE, selection = "single", server = TRUE,
                                     options = list(pageLength = 25))
  

  #show selected rows in other table
  tb_sdg2_selected <- reactive({
    ids <- input$dTable_rows_selected
    t(mylongtable()[ids,])
  })
  
  output$longtable <- DT::renderDataTable({tb_sdg2_selected()}, escape = FALSE, server = TRUE,
                                          options = list(pageLength = 25), selection = "none")
  

}