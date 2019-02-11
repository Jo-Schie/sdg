# filter 
f_filter <- function(min_year, max_year, my_country = "any", my_target="any") {
  tb_sdg<-tb_sdg[tb_sdg2$Start<=max_year&
                     tb_sdg2$End>=min_year,]
  if (my_country !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$country==my_country,]
  } 
  if (my_target !="any") {
    tb_sdg2 <- tb_sdg2[tb_sdg2$target==my_target,]
  }
  tb_sdg2<-tb_sdg2[,c("target","Name","country","Start","End","Access")]
  return(tb_sdg2)
}