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
  
  output$dTable<-renderDataTable({mytable()})
  
}