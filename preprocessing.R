# Preparing reference for convertion of region into countries
source("countries.R")
source("goal_target_separated.R")
# Download the data from the online-sheet and load
drive_download(as_id("1CXGo4Zh8i7R4aLlCmdqKbNr9qH5xeH9Lq2h3-UMqWh4"),type = "csv",overwrite = TRUE)
tb_sdg<-read.csv("Test for IndicatorDB (Antworten).csv", stringsAsFactors = FALSE)

# Replace NAs by empty values
tb_sdg[is.na(tb_sdg)] <- ""

# Concatenate targets
tb_sdg <- tb_sdg %>%
  unite("target", starts_with("Which.target"), sep = "")

#load list of prepared datasets (MICS,...)
source("survey_sources.R")

# Fill-in countries if global
n_max_country <- nrow(geo_tags)

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



### convert start-date
tb_sdg2$Start[tb_sdg2$Start=="before 1990"]<-"1990"
tb_sdg2$Start<-as.numeric(as.character(tb_sdg2$Start))

#create columns with no NA values for Start and End date. They will be used for the filter, whereas the table renders the NA`s
tb_sdg2 <- tb_sdg2 %>%
  mutate(Start_mod = ifelse(is.na(Start), 1990, Start),
         End_mod = ifelse(is.na(End), 10000, End))



#create levels to order targets
sdg_f <- tibble(sdgs = unique(tb_sdg2$target),
                sdg_i = (str_extract(sdgs, "^[0-9]+")),
                sdg_j = str_extract(sdgs, "\\.(.+)\\:")) %>%
  arrange(as.numeric(sdg_i), sdg_j)



tb_sdg2 <- tb_sdg2 %>%
  mutate(target = factor(target, levels = c(sdg_f$sdgs)))


# join target_tb (with separated goal and target) with sdg2 and rename some column names for better readibility
sdg_f <- sdg_f %>%
  mutate(sdg_j2 = str_remove(sdg_j, ":"),
         index = paste0(sdg_i, sdg_j2)) %>%
  left_join(target_tb, by = "index")



tb_sdg2 <- tb_sdg2 %>%
  left_join(sdg_f, by = c("target" = "sdgs")) %>%
  rename(`Target long` = target) %>%
  rename(Country = country) %>%
  rename(goal_not_ordinal = goal) %>%
  rename(`Data origin` = `Data.generation`) %>% rename(`Spatial resolution` = `What.is.the.HIGHEST.spatial.resolution.of.this.data.`) %>%
  rename(Update = `How.often.the.data.are.updated`) %>%
  rename(`Account needed?` = `Is.an.account.needed.`) %>%
  mutate(Target = paste(index, `target.y`)) %>%
  mutate(Goal = paste0(sdg_i, ": ", goal_not_ordinal))

#create levels to order targets
sdg_factor_target <- tibble(sdgs = unique(tb_sdg2$Target),
                            sdg_i = (str_extract(sdgs, "^[0-9]+")),
                            sdg_j = str_remove(str_extract(unique(tb_sdg2$Target), "\\.(..?) "), " ")) %>%
  arrange(as.numeric(sdg_i), sdg_j)

tb_sdg2 <- tb_sdg2 %>%
  mutate(Target = factor(Target, levels = c(sdg_factor_target$sdgs)))

#create levels to order goals
sdg_factor_goal <- tibble(sdg = unique(tb_sdg2$Goal),
                          sdg_i = (str_extract(sdg, "^[0-9]+"))) %>%
  arrange(as.numeric(sdg_i))

tb_sdg2 <- tb_sdg2 %>%
  mutate(Goal = factor(Goal, levels = c(sdg_factor_goal$sdg)))

# transform links to proper html links

tb_sdg2$Access <- paste0("<a href='",tb_sdg2$Access,"'>",tb_sdg2$Access,"</a>")

#concatenate spatial resolution with adm level when spatial res = irregular
tb_sdg2$`Spatial resolution` = ifelse(tb_sdg2$`Spatial resolution` == "irregular (e.g. administrative areas)",
                               tb_sdg2$`In.which.administrative.level.the.data.are.available.`,
                               tb_sdg2$`Spatial resolution`)
  

#concatenate updates(yes/no) with update frequency when updates =yes
tb_sdg2$Updates = ifelse(tb_sdg2$Updates == "Yes", tb_sdg2$Update, tb_sdg2$Updates)