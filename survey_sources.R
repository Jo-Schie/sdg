# Script by FB to prepare the list of available datasets 
# and load them into locateSDG

# Tidyverse style!
library(readr)
library(stringr)
library(dplyr)

# Download all available surveys and census from ihsn (max = 20K, actual ~6K)
download.file(url = "http://catalog.ihsn.org/index.php/catalog/export/csv?ps=20000&collection[]=", 
              destfile = "ihsn.csv")

# Load the data
ihsn <- read_csv("ihsn.csv")

# strings/patterns in survey titles that are characteristics to survey type
dhs_str <- "Demographic and Health Survey|Démographique et de Santé|Demografía y Salud|Demografia e Saúde"
mics_str <- "Multiple Indicator|Indicadores Múltipl|Indicateurs Multiples"
# TODO: Add new patterns to identify other sources: Afrobarometer, LSMS...


# columns selecting surveys according to survey type
ihsn_src <- ihsn %>%
  mutate(Source = ifelse(str_detect(title, dhs_str), "DHS", ""),
         Source = ifelse(str_detect(title, mics_str), "MICS", Source)) %>%
# TODO: add new classes matching the added patterns (Afrobarometer, LSMS...)
  filter(Source != "") %>%
  select(Which.countries.are.covered..1 = nation,
         Start = year_start,
         End = year_end,
         Source)

# Extract classified sources
ihsn_sources <- unique(ihsn_src$Source)

# Populates survey-country-date from IHSN with Google sheet info
src_replace <- tb_sdg %>%
  filter(Source %in% ihsn_sources) %>%
  select(-Which.countries.are.covered..1, -Start, -End) %>%
  full_join(ihsn_src, by = "Source") %>%
  mutate(Start = as.character(Start))

# Deletes the generic sources from tb_sdg 
# and replaces with detailed sources from IHSN
tb_sdg <- tb_sdg %>%
  filter(!(Source %in% ihsn_sources)) %>%
  bind_rows(src_replace)


