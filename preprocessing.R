# Preparing reference for convertion of region into countries
source("countries.R")

# Download the data from the online-sheet and load
drive_download(as_id("1CXGo4Zh8i7R4aLlCmdqKbNr9qH5xeH9Lq2h3-UMqWh4"),type = "csv",overwrite = TRUE)
tb_sdg<-read.csv("Test for IndicatorDB (Antworten).csv", stringsAsFactors = FALSE)

# Replace NAs by empty values
tb_sdg[is.na(tb_sdg)] <- ""

# Concatenate targets
tb_sdg <- tb_sdg %>%
  unite("target", starts_with("Which.target"), sep = "")

# Fill-in countries if global
n_max_country <- max(str_count(tb_sdg$Which.countries.are.covered..1, ","))+1

country_vars <- paste0("country_", 1:n_max_country)
to_keep <- colnames(tb_sdg)
tb_sdg2 <- tb_sdg %>% # filling countries if only global or continent
  mutate(country_init = `Which.countries.are.covered..1`,
         country_init = ifelse(`Geographic.coverage` == "Global",
                               paste(geo_tags$country, collapse = ","), 
                               country_init),
         country_init = ifelse(`Geographic.coverage` == "Continental",
                               paste(geo_tags$country[geo_tags$continent %in% strsplit(tb_sdg$`Which.continents.are.covered.`, ", ")], 
                                     collapse = ","),
                               country_init))  %>% 
  separate(country_init, country_vars, sep = ",", remove = TRUE) %>%
  gather(to_delete, country, -(to_keep)) %>% # Long form
  select(-to_delete) %>% # delete empty lines
  filter(country != "" & !is.na(country))

# trim country to assure unique values
tb_sdg2$country <- trimws(tb_sdg2$country)
sort(unique(tb_sdg2$country))



# convert start-date
tb_sdg2$Start[tb_sdg2$Start=="before 1990"]<-"1990"
tb_sdg2$Start<-as.numeric(as.character(tb_sdg2$Start))
# what to do with undefined in this column?


#create levels to order targets
sdg_f <- tibble(sdgs = unique(tb_sdg2$target),
                sdg_i = (str_extract(sdgs, "^[0-9]+")),
                sdg_j = str_extract(sdgs, "\\.(.+)\\:")) %>%
  arrange(as.numeric(sdg_i), sdg_j)

tb_sdg2 <- tb_sdg2 %>%
  mutate(target = factor(target, levels = c(sdg_f$sdgs)))
levels(tb_sdg2$target)
