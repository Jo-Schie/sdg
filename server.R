# create the server function
server<-function(input,output){
  mytable<-reactive({f_filter(min_year = input$timeline[1],
                              max_year = input$timeline[2],
                              input$country,
                              input$target)})
  output$dTable<-renderDataTable({mytable()})
  
}