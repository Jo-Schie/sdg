# filter 
f_filter <- function(min_year, max_year, my_country = "any", my_target="any", my_goal = "any") {
  tb_sdg2<-tb_sdg2[tb_sdg2$Start_mod<=max_year&
                     tb_sdg2$End_mod>=min_year,]
  if (my_country !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$Country==my_country,]
  } 
  if (my_target !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$Target==my_target,]
  }
  if (my_goal !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$Goal==my_goal,]
  }
  tb_sdg2<-tb_sdg2[,c("Goal", "Target", "Name", "Country", "Start", "End")]
  return(tb_sdg2)
}


# filter 
f_filter_long <- function(min_year, max_year, my_country = "any", my_target="any", my_goal = "any") {
  tb_sdg2<-tb_sdg2[tb_sdg2$Start_mod<=max_year&
                     tb_sdg2$End_mod>=min_year,]
  if (my_country !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$Country==my_country,]
  } 
  if (my_target !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$Target==my_target,]
  }
  if (my_goal !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$Goal==my_goal,]
  }
  tb_sdg2<-tb_sdg2[,c("Goal", "Target long", "Name","Objective", "Country", "Start", "End","Data origin", "Type", "Spatial resolution",
                      "Source", "Access", "Comments", "Updates", "Account needed?")]

  return(tb_sdg2)
}