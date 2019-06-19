# load libraries
library(shiny)
library(DT)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(shinythemes)
library(shinyjs)
library(rvest)
library(purrr)



# create country references
country <- c("Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", 
             "Australia", "Austria", "Azerbaijan", "Bahamas (The)", "Bahrain", "Bangladesh", "Barbados", "Belarus", 
             "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", 
             "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", 
             "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo (Democratic Republic of the)", 
             "Congo (Republic of the)", "Cook Islands", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", 
             "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea",
             "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia (The)", 
             "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", 
             "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", 
             "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea (North)", 
             "Korea (South)", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", 
             "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia (North)", "Madagascar", "Malawi", 
             "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", 
             "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", 
             "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", 
             "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", 
             "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", 
             "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", 
             "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", 
             "Solomon Islands", "Somalia", "South Africa", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", 
             "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo",
             "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", 
             "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City",
             "Venezuela", "Vietnam", "Western Sahara", "Yemen", "Zambia", "Zimbabwe")

region <- c("South Central Asia", "Southern Europe", "North Africa", "Southern Europe", "Central Africa", "Caribbean", 
            "South America", "Western Asia", "Australia/Oceania", "Western Europe", "Western Asia", "Caribbean", 
            "Middle East", "South Central Asia", "Caribbean", "Eastern Europe", "Western Europe", "Central America", 
            "West Africa", "South Central Asia", "South America", "Southern Europe", "Southern Africa", "South America", 
            "Southeast Asia", "Eastern Europe", "West Africa", "Eastern Africa", "Southeast Asia", "Central Africa", 
            "North America", "West Africa", "Central Africa", "Central Africa", "South America", "Eastern Asia", 
            "South America", "Eastern Africa", "Central Africa", "Central Africa", "Oceania/Polynesia", "Central America", 
            "Southern Europe", "Caribbean", "Western Asia", "Eastern Europe", "Northern Europe", "Eastern Africa", 
            "Caribbean", "Caribbean", "South America", "North Africa", "Central America", "Central Africa", 
            "Eastern Africa", "Northern Europe", "Southern Africa", "Eastern Africa", "Oceania/Melanesia", "Northern Europe", 
            "Western Europe", "Central Africa", "West Africa", "Western Asia", "Western Europe", "West Africa", 
            "Southern Europe", "Caribbean", "Central America", "West Africa", "West Africa", "South America", "Caribbean", 
            "Central America", "Eastern Europe", "Northern Europe", "South Central Asia", "Southeast Asia", 
            "South Central Asia", "Middle East", "Northern Europe", "Middle East", "Southern Europe", "West Africa", 
            "Caribbean", "Eastern Asia", "Middle East", "South Central Asia", "Eastern Africa", "Oceania/Micronesia", 
            "Eastern Asia", "Eastern Asia" ,"Southern Europe", "Middle East", "South Central Asia", "Southeast Asia", 
            "Northern Europe", "Middle East", "Southern Africa", "West Africa", "North Africa", "Western Europe", 
            "Northern Europe", "Western Europe", "Southern Europe", "Eastern Africa", "Eastern Africa", "Southeast Asia", 
            "South Central Asia", "West Africa", "Southern Europe", "Oceania/Micronesia", "West Africa", "Eastern Africa", 
            "North America", "Oceania/Micronesia", "Eastern Europe", "Southern Europe", "Eastern Asia", "Southern Europe", 
            "North Africa", "Eastern Africa", "Southeast Asia", "Southern Africa", "Oceania/Micronesia", "South Central Asia", 
            "Western Europe", "Australia/Oceania", "Central America", "West Africa", "West Africa", "Oceania/Polynesia", 
            "Northern Europe", "Middle East", "South Central Asia", "Oceania/Micronesia", "Middle East", "Central America", 
            "Oceania/Melanesia", "South America", "South America", "Southeast Asia", "Eastern Europe", "Southern Europe", 
            "Middle East", "Eastern Europe", "Eastern Europe", "Eastern Africa", "Caribbean", "Caribbean", "Caribbean", 
            "Oceania/Polynesia", "Southern Europe", "West Africa", "Middle East", "West Africa", "Southern Europe", 
            "Eastern Africa", "West Africa", "Southeast Asia", "Eastern Europe", "Southern Europe", "Oceania/Melanesia", 
            "Eastern Africa", "Southern Africa", "North Africa", "Southern Europe", "South Central Asia", "North Africa", 
            "South America", "Northern Europe", "Western Europe", "Middle East", "Eastern Asia", "South Central Asia", 
            "Eastern Africa", "Southeast Asia", "Southeast Asia", "West Africa", "Oceania/Polynesia", "Caribbean", 
            "North Africa", "Western Asia", "South Central Asia", "Oceania/Polynesia", "Eastern Africa", "Eastern Europe", 
            "Middle East", "Northern Europe", "North America", "South America", "South Central Asia", "Oceania/Melanesia", 
            "Southern Europe", "South America", "Southeast Asia", "West Africa", "Middle East", "Eastern Africa", 
            "Eastern Africa")

continent <- c("Asia", "Europe", "Africa", "Europe", "Africa", "North America", "South America", "Asia", "Oceania", 
               "Europe", "Asia", "North America", "Asia", "Asia", "North America", "Europe", "Europe", 
               "North America","Africa", "Asia", "South America", "Europe", "Africa", "South America", "Asia", 
               "Europe", "Africa", "Africa", "Asia", "Africa", "North America", "Africa", "Africa", "Africa", 
               "South America", "Asia", "South America", "Africa", "Africa", "Africa", "Oceania", "North America", 
               "Europe", "North America", "Asia", "Europe", "Europe", "Africa", "North America", "North America", 
               "South America", "Africa", "North America", "Africa", "Africa", "Europe", "Africa", "Africa", 
               "Oceania", "Europe", "Europe", "Africa", "Africa", "Asia", "Europe", "Africa", "Europe", 
               "North America", "North America", "Africa", "Africa", "South America", "North America", 
               "North America", "Europe", "Europe", "Asia", "Asia", "Asia", "Asia", "Europe", "Asia", "Europe", 
               "Africa", "North America", "Asia", "Asia", "Asia", "Africa", "Oceania", "Asia", "Asia", "Europe", 
               "Asia", "Asia", "Asia", "Europe", "Asia", "Africa", "Africa", "Africa", "Europe", "Europe", 
               "Europe", "Europe", "Africa", "Africa", "Asia", "Asia", "Africa", "Europe", "Oceania", "Africa", 
               "Africa", "North America", "Oceania", "Europe", "Europe", "Asia", "Europe", "Africa", "Africa", 
               "Asia", "Africa", "Oceania", "Asia", "Europe", "Oceania", "North America", "Africa", "Africa", 
               "Oceania", "Europe", "Asia", "Asia", "Oceania", "Asia", "North America", "Oceania", "South America", 
               "South America", "Asia", "Europe", "Europe", "Asia", "Europe", "Europe", "Africa", "North America", 
               "North America", "North America", "Oceania",  "Europe", "Africa", "Asia", "Africa", "Europe", 
               "Africa", "Africa", "Asia", "Europe", "Europe", "Oceania", "Africa", "Africa", "Africa", "Europe", 
               "Asia", "Africa", "South America", "Europe", "Europe", "Asia", "Asia", "Asia", "Africa", "Asia", 
               "Asia", "Africa", "Oceania", "North America", "Africa", "Europe", "Asia", "Oceania", "Africa", 
               "Europe", "Asia", "Europe", "North America", "South America", "Asia", "Oceania", "Europe", 
               "South America", "Asia", "Africa", "Asia", "Africa", "Africa")
geo_tags <- tibble(country, region, continent)


ihsn_countries <- tibble::tribble(
  ~ ihsn_cnames,
  ~ gspread,
  "Afghanistan",  "Afghanistan",  "Albania",  "Albania",  "Algeria",  "Algeria",  "Angola",  "Angola",  "Anguilla",  "United Kingdom",  "Antigua and Barbuda",  "Antigua and Barbuda",  "Argentina",
  "Argentina",  "Armenia",  "Armenia",  "Aruba",  "Netherlands",  "Australia",  "Australia",  "Austria",  "Austria",  "Azerbaijan",  "Azerbaijan",  "Bahamas, The",  "Bahamas (The)",  "Bahrain",
  "Bahrain",  "Bangladesh",  "Bangladesh",  "Barbados",  "Barbados",  "Belarus",  "Belarus",  "Belgium",  "Belgium",  "Belize",  "Belize",  "Benin",  "Benin",  "Bhutan",  "Bhutan",  "Bolivia",
  "Bolivia",  "Bosnia and Herzegovina",  "Bosnia and Herzegovina",  "Botswana",  "Botswana",  "Brazil",  "Brazil",  "British Virgin Islands",  "United Kingdom",  "Brunei Darussalam",  "Brunei",
  "Bulgaria",  "Bulgaria",  "Burkina Faso",  "Burkina Faso",  "Burundi",  "Burundi",  "Cambodia",  "Cambodia",  "Cameroon",  "Cameroon",  "Canada",  "Canada",  "Cayman Islands",  "United Kingdom",
  "Central African Republic",  "Central African Republic",  "Chad",  "Chad",  "Chile",  "Chile",  "China",  "China",  "Colombia",  "Colombia",  "Comoros",  "Comoros",  "Congo Democratic Republic",
  "Congo (Democratic Republic of the)",  "Congo, Dem. Rep.",  "Congo (Democratic Republic of the)",  "Congo, Rep.",  "Congo (Republic of the)",  "Cook Islands",  "Cook Islands",  "Costa Rica",
  "Costa Rica",  "Cote d'Ivoire", "Ivory Coast", "Côte d'Ivoire", "Ivory Coast", "Cote d'Ivoire",  "Ivory Coast",  "Côte d'Ivoire",  "Ivory Coast",  "Croatia",  "Croatia",  "Cuba",  "Cuba",
  "Cyprus",  "Cyprus",  "Czech Republic",  "Czech Republic",  "Denmark",  "Denmark",  "Djibouti",  "Djibouti",  "Dominica",  "Dominica",  "Dominican Republic",  "Dominican Republic",  "DPR Korea",
  "Korea (North)",  "ECA Region",  NA,  "Ecuador",  "Ecuador",  "Egypt",  "Egypt",  "Egypt, Arab Rep.",  "Egypt",  "El Salvador",  "El Salvador",  "Equatorial Guinea",  "Equatorial Guinea",
  "Eritrea",  "Eritrea",  "Estonia",  "Estonia",  "Ethiopia",  "Ethiopia",  "EU Region",  NA,  "Europe and Central Asia",  NA,  "Federated States of Micronesia",  "Micronesia",  "Fiji",  "Fiji",
  "Finland",  "Finland",  "France",  "France",  "Gabon",  "Gabon",  "Gambia", "Gambia (The)",  "Gambia, The", "Gambia (The)",  "Georgia",  "Georgia",  "Germany",  "Germany",  "Ghana",  "Ghana",  "Greece",  "Greece",
  "Grenada",  "Grenada",  "Grenada, Dominica, St. Vincent & Grenadines, Antigua and Barbuda",  NA,  "Guatemala",  "Guatemala",  "Guinea",  "Guinea",  "Guinea-Bissau",  "Guinea-Bissau",  
  "Guyana",  "Guyana",  "Haiti",  "Haiti",  "Honduras",  "Honduras",  "Hong Kong SAR, China",  "China",  "Hungary",  "Hungary",  "Iceland",  "Iceland",  "India",  "India",  "India, Pakistan",  NA,
  "Indonesia",  "Indonesia",  "Iran, Islamic Rep.",  "Iran",  "Iraq",  "Iraq",  "Ireland",  "Ireland",  "Israel",  "Israel",  "Italy",  "Italy",  "Jamaica",  "Jamaica",  "Japan",  "Japan",  "Jordan",
  "Jordan",  "Kazakhstan",  "Kazakhstan",  "Kenya",  "Kenya",  "Kingdom of Eswatini",  "Eswatini",  "Kiribati",  "Kiribati",  "Korea, Rep.",  "Korea (South)",  "Kosovo",  "Kosovo",  "Kuwait",
  "Kuwait",  "Kyrgyz Republic",  "Kyrgyzstan",  "Lao PDR",  "Laos",  "Latin America",  NA,  "Latvia",  "Latvia",  "Lebanon",  "Lebanon",  "Lesotho",  "Lesotho",  "Liberia",  "Liberia",  "Libya",
  "Libya",  "Lithuania",  "Lithuania",  "Luxembourg",  "Luxembourg",  "Macedonia, FYR",  "Macedonia (North)",  "Madagascar",  "Madagascar",  "Malawi",  "Malawi",  "Malaysia",  "Malaysia",  "Maldives",
  "Maldives",  "Mali",  "Mali",  "Malta",  "Malta",  "Marshall Islands",  "Marshall Islands",  "Mauritania",  "Mauritania",  "Mauritius",  "Mauritius",  "Mexico",  "Mexico",  "Micronesia, Fed. Sts.",
  "Micronesia",  "Moldova",  "Moldova",  "Mongolia",  "Mongolia",  "Montenegro",  "Montenegro",  "Montserrat",  "United Kingdom",  "Morocco",  "Morocco",  "Mozambique",  "Mozambique",  "Myanmar",
  "Myanmar",  "Namibia",  "Namibia",  "Nauru",  "Nauru",  "Nepal",  "Nepal",  "Netherlands",  "Netherlands",  "New Zealand",  "New Zealand",  "Nicaragua",  "Nicaragua",  "Niger",  "Niger",  "Nigeria",
  "Nigeria",  "Niue",  "Niue",  "North Macedonia",  "Macedonia (North)",  "Norway",  "Norway",  "Oman",  "Oman",  "Pakistan",  "Pakistan",  "Palau", "Palau",  "Panama",  "Panama",  "Papua New Guinea",
  "Papua New Guinea",  "Paraguay",  "Paraguay",  "Peru",  "Peru",  "Philippines",  "Philippines",  "Poland",  "Poland",  "Portugal",  "Portugal",  "Puerto Rico",  "United States",  "Qatar",  "Qatar",
  "Republic of Cabo Verde",  "Cape Verde",  "Romania",  "Romania",  "Russian Federation",  "Russia",  "Rwanda",  "Rwanda",  "Samoa",  "Samoa",  "São Tomé and Principe",  "Sao Tome and Principe",
  "São Tomé and Príncipe",  "Sao Tome and Principe",  "Saudi Arabia",  "Saudi Arabia",  "Senegal",  "Senegal",  "Sénégal",  "Senegal",  "Serbia",  "Serbia",  "Serbia and Montenegro",  NA,  "Seychelles",
  "Seychelles",  "Sierra Leone",  "Sierra Leone",  "Singapore",  "Singapore",  "Slovak Republic",  "Slovakia",  "Slovenia",  "Slovenia",  "Solomon Islands",  "Solomon Islands",  "Somalia",  "Somalia",
  "South Africa",  "South Africa",  "South Africa,",  "South Africa",  "South Sudan",  "South Sudan",  "Spain",  "Spain",  "Sri Lanka",  "Sri Lanka",  "St. Kitts and Nevis",  "Saint Kitts and Nevis",
  "St. Lucia",  "Saint Lucia",  "St. Vincent & Grenadines",  "Saint Vincent and the Grenadines",  "St. Vincent and the Grenadines",  "Saint Vincent and the Grenadines",  "Sudan",  "Sudan",  "Suriname",
  "Suriname",  "Swaziland",  "Eswatini",  "Sweden",  "Sweden",  "Switzerland",  "Switzerland",  "Syrian Arab Republic",  "Syria",  "Taiwan, China",  "Taiwan",  "Tajikistan",  "Tajikistan",  "Tanzania",
  "Tanzania",  "Thailand",  "Thailand",  "Timor-Leste",  "Timor-Leste",  "Timor Leste",  "Timor-Leste", "Togo",  "Togo",  "Tonga",  "Tonga",  "Trinidad and Tobago",  "Trinidad and Tobago",  "Tunisia",
  "Tunisia",  "Turkey",  "Turkey",  "Turkmenistan",  "Turkmenistan",  "Tuvalu",  "Tuvalu",  "Uganda",  "Uganda",  "Ukraine",  "Ukraine",  "United Arab Emirates",  "United Arab Emirates",
  "United Kingdom",  "United Kingdom",  "United States",  "United States",  "Uruguay",  "Uruguay",  "Uzbekistan",  "Uzbekistan",  "Vanuatu",  "Vanuatu",  "Venezuela, RB",  "Venezuela",  "Viet Nam",
  "Vietnam",  "Vietnam",  "Vietnam",  "West Bank and Gaza",  "Palestine",  "World",  NA,  "Yemen, Rep.",  "Yemen",  "Zambia",  "Zambia",  "Zimbabwe",  "Zimbabwe"
)

lsms_countries <- c("Albania", "Albania","Albania", "Albania", "Albania", "Albania", "Albania", "Armenia", "Azerbaijan", "Bosnia and Herzegovina", "Bosnia and Herzegovina",
                    "Bosnia and Herzegovina", "Bosnia and Herzegovina", "Bosnia and Herzegovina", "Brazil", "Bulgaria", "Bulgaria", "Bulgaria", "Bulgaria", "Bulgaria", "Burkina Faso",
                    "China", "Côte d'Ivoire", "Côte d'Ivoire", "Côte d'Ivoire", "Côte d'Ivoire", "Ecuador", "Ecuador", "Ethiopia", "Ethiopia", "Ethiopia", "Ethiopia", "Ghana", "Ghana",
                    "Ghana", "Ghana", "Ghana", "Guatemala", "Guyana", "India", "Iraq", "Iraq", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica",
                    "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Kazakhstan", "Kosovo", "Kyrgyz Republic", "Kyrgyz Republic", "Kyrgyz Republic", "Kyrgyz Republic",
                    "Malawi", "Malawi", "Malawi", "Malawi", "Malawi", "Mali", "Mali", "Nepal", "Nepal", "Nepal", "Nicaragua", "Nicaragua", "Nicaragua", "Nicaragua", "Niger", "Niger",
                    "Nigeria", "Nigeria", "Nigeria", "Nigeria", "Pakistan", "Panama", "Panama", "Panama", "Peru", "Peru", "Peru", "Peru", "Serbia", "Serbia and Montenegro", "Serbia and Montenegro",
                    "South Africa", "Tajikistan", "Tajikistan", "Tajikistan", "Tajikistan", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania",
                    "Tanzania", "Tanzania", "Tanzania", "Timor-Leste", "Timor-Leste", "Uganda", "Uganda", "Uganda", "Uganda", "Uganda", "Vietnam", "Vietnam", "Vietnam", "Vietnam", "Vietnam")

app_countries <- c("Albania", "Albania", "Albania", "Albania", "Albania", "Albania", "Albania", "Armenia", "Azerbaijan", "Bosnia and Herzegovina", "Bosnia and Herzegovina",
                   "Bosnia and Herzegovina", "Bosnia and Herzegovina", "Bosnia and Herzegovina", "Brazil", "Bulgaria", "Bulgaria", "Bulgaria", "Bulgaria", "Bulgaria", "Burkina Faso",
                   "China", "Ivory Coast", "Ivory Coast", "Ivory Coast", "Ivory Coast", "Ecuador", "Ecuador", "Ethiopia", "Ethiopia", "Ethiopia", "Ethiopia", "Ghana", "Ghana", "Ghana",
                   "Ghana", "Ghana", "Guatemala", "Guyana", "India", "Iraq", "Iraq", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Jamaica",
                   "Jamaica", "Jamaica", "Jamaica", "Jamaica", "Kazakhstan", "Kosovo", "Kyrgyzstan", "Kyrgyzstan", "Kyrgyzstan", "Kyrgyzstan", "Malawi", "Malawi", "Malawi", "Malawi", "Malawi",
                   "Mali", "Mali", "Nepal", "Nepal", "Nepal", "Nicaragua", "Nicaragua", "Nicaragua", "Nicaragua", "Niger", "Niger", "Nigeria", "Nigeria", "Nigeria", "Nigeria", "Pakistan",
                   "Panama", "Panama", "Panama", "Peru", "Peru", "Peru", "Peru", "Serbia", "Serbia, Montenegro", "Serbia, Montenegro", "South Africa", "Tajikistan", "Tajikistan", "Tajikistan",
                   "Tajikistan", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Tanzania", "Timor-Leste", "Timor-Leste",
                   "Uganda", "Uganda", "Uganda", "Uganda", "Uganda", "Vietnam", "Vietnam", "Vietnam", "Vietnam", "Vietnam")

lsms_countries <- tibble(lsms_countries, app_countries)



target_tb <- tribble(
  ~index,                                      ~goal,                                                                                    ~target,
  "1.1",                               "No Poverty",                                                                "Eradicate extreme poverty",
  "1.2",                               "No Poverty",                                                                           "Reduce by half",
  "1.3",                               "No Poverty",                                                                "Social protection systems",
  "1.4",                               "No Poverty",                                                                             "Equal rights",
  "1.5",                               "No Poverty",                                                            "Resilience to economic shocks",
  "1.a",                               "No Poverty",                                                                "Mobilization of resources",
  "1.b",                               "No Poverty",                                                                        "Policy frameworks",
  "2.1",                              "Zero Hunger",                                                                   "Ensure sufficient food",
  "2.2",                              "Zero Hunger",                                                                         "End malnutrition",
  "2.3",                              "Zero Hunger",                                                         "Double agricultural productivity",
  "2.4",                              "Zero Hunger",                                                              "Sustainable food production",
  "2.5",                              "Zero Hunger",                                                               "Maintain genetic diversity",
  "2.a",                              "Zero Hunger",                                                                      "Increase investment",
  "2.b",                              "Zero Hunger",                                                               "Prevent trade restrictions",
  "2.c",                              "Zero Hunger",                                                    "Functioning of food commodity markets",
  "3.1",               "Good Health and Well-Being",                                                   "Reduce global maternal mortality ratio",
  "3.2",               "Good Health and Well-Being",                                           "Reduce deaths of newborns and children under 5",
  "3.3",               "Good Health and Well-Being",                                                                            "End epidemics",
  "3.4",               "Good Health and Well-Being",                               "Reduce pre-mature mortality from non communicable diseases",
  "3.5",               "Good Health and Well-Being",                                                                 "Fighting substance abuse",
  "3.6",               "Good Health and Well-Being",                                                 "Halve deaths in road traffic accididents",
  "3.7",               "Good Health and Well-Being",                                                    "Access to sexual health-care services",
  "3.8",               "Good Health and Well-Being",                                                        "Achieve universal health coverage",
  "3.9",               "Good Health and Well-Being",                                                              "Reduce death from pollution",
  "3.a",               "Good Health and Well-Being",                                                                          "Tobacco control",
  "3.b",               "Good Health and Well-Being",                                                               "Promote R&D of vaccines...",
  "3.c",               "Good Health and Well-Being",                                                                "Increase health financing",
  "3.d",               "Good Health and Well-Being",                                                     "Improve early warning risk reduction",
  "4.1",                        "Quality Education",                                                     "Free primary and secondary education",
  "4.2",                        "Quality Education",                                                    "Access to early childhood development",
  "4.3",                        "Quality Education",                                                       "Equal access to tertiary education",
  "4.4",                        "Quality Education",                                                                 "Increase relevant skills",
  "4.5",                        "Quality Education",                                                                             "Equal access",
  "4.6",                        "Quality Education",                                                                    "Literacy and numeracy",
  "4.7",                        "Quality Education",                                                "Skills to promote sustainable development",
  "4.a",                        "Quality Education",                                                           "Educational facilities for all",
  "4.b",                        "Quality Education",                                                                      "Expand scholarships",
  "4.c",                        "Quality Education",                                                    "Increase supply of qualified teachers",
  "5.1",                          "Gender Equality",                                                         "End discrimination against women",
  "5.2",                          "Gender Equality",                                                         "Eliminate violence against women",
  "5.3",                          "Gender Equality",                                                                    "End harmful practices",
  "5.4",                          "Gender Equality",                                                  "Recognize unpaid care and domestic work",
  "5.5",                          "Gender Equality",                                       "Promote women's equal opportunities for leadership",
  "5.6",                          "Gender Equality",                                                        "Universal access to sexual health",
  "5.a",                          "Gender Equality",                                            "Reforms for equal access to land ownership...",
  "5.b",                          "Gender Equality",                                                       "Technology for women's empowerment",
  "5.c",                          "Gender Equality",                                                  "Strenghten policies for gender equality",
  "6.1",               "Clean Water and Sanitation",                                                                 "Access to drinking water",
  "6.2",               "Clean Water and Sanitation",                                                         "Access to sanitation and hygiene",
  "6.3",               "Clean Water and Sanitation",                                                                    "Improve water quality",
  "6.4",               "Clean Water and Sanitation",                                                            "Increase water-use efficiency",
  "6.5",               "Clean Water and Sanitation",                                                      "Implement water resource management",
  "6.6",               "Clean Water and Sanitation",                                                         "Protect water related ecosystems",
  "6.a",               "Clean Water and Sanitation",                                                        "Expand international cooperation",
  "6.b",               "Clean Water and Sanitation",                                                               "Support local communities",
  "7.1",              "Affordable and Clean Energy",                                                         "Access to modern energy services",
  "7.2",              "Affordable and Clean Energy",                                                       "Increase share of renewable energy",
  "7.3",              "Affordable and Clean Energy",                                                                "Improve energy efficiency",
  "7.a",              "Affordable and Clean Energy",                                                       "Enhance international cooperation",
  "7.b",              "Affordable and Clean Energy",                                                                   "Expand infrastructure",
  "8.1",          "Decent Work and Economic Growth",                                                                "Sustain per capita growth",
  "8.2",          "Decent Work and Economic Growth",                                                    "Higher level of economic productivity",
  "8.3",          "Decent Work and Economic Growth",                                                    "Promote development-oriented policies",
  "8.4",          "Decent Work and Economic Growth",                                                   "Enhance resource efficiency, decouple",
  "8.5",          "Decent Work and Economic Growth",                                                                          "Full employment",
  "8.6",          "Decent Work and Economic Growth",                                                        "Reduce youth not in employment ..",
  "8.7",          "Decent Work and Economic Growth",                                                                      "Fight forced labour",
  "8.8",          "Decent Work and Economic Growth",                                                                    "Protect labour rights",
  "8.9",          "Decent Work and Economic Growth",                                                              "Promote sustainable tourism",
  "8.10",          "Decent Work and Economic Growth",                                              "Strengthen domestic financial institutions",
  "8.a",          "Decent Work and Economic Growth",                                                           "Increase aid for trade support",
  "8.b",          "Decent Work and Economic Growth",                                                          "Strategy for youth unemployment",
  "9.1", "Industries Innovation and Infrastructure",                                                                "Develop infrastructure...",
  "9.2", "Industries Innovation and Infrastructure",                                                    "Promote sustainable industrialization",
  "9.3", "Industries Innovation and Infrastructure",                                                    "Increase access to financial services",
  "9.4", "Industries Innovation and Infrastructure",                                                "Promote environmental friendly industries",
  "9.5", "Industries Innovation and Infrastructure",                                                                   "Encouraging innovation",
  "9.a", "Industries Innovation and Infrastructure",                                                           "Enhance technological support",
  "9.b", "Industries Innovation and Infrastructure",                                                 "Support domestic technology developement",
  "9.c", "Industries Innovation and Infrastructure",                                         "Increase access to information and communication",
  "10.1",                     "Reduced Inequalities",                                                           "Income growth of the lower 40%",
  "10.2",                     "Reduced Inequalities",                                                                                "Inclusion",
  "10.3",                     "Reduced Inequalities",                                                      "Eliminating discriminatory laws,...",
  "10.4",                     "Reduced Inequalities",                                                              "Adopt policies for equality",
  "10.5",                     "Reduced Inequalities",                                      "Regulation and monitoring of global financial market",
  "10.6",                     "Reduced Inequalities",                                          "Enhanced representation of developing countries",
  "10.7",                     "Reduced Inequalities",                                        "Implementation of well-managed migration policies",
  "10.a",                     "Reduced Inequalities",                              "Special and differential treatment for developing countries",
  "10.b",                     "Reduced Inequalities",                                                         "Encourage development assistance",
  "10.c",                     "Reduced Inequalities",                                                                 "Reduce transaction costs",
  "11.1",       "Sustainable Cities and Communities",                                                                             "Safe housing",
  "11.2",       "Sustainable Cities and Communities",                                                          "Access to safe public transport",
  "11.3",       "Sustainable Cities and Communities",                                                                 "Sustainable urbanization",
  "11.4",       "Sustainable Cities and Communities",                                                        "Protect world's cultural heritage",
  "11.5",       "Sustainable Cities and Communities",                                                        "Reduce losses caused by disasters",
  "11.6",       "Sustainable Cities and Communities",                                                    "Reduce environmental impact of cities",
  "11.7",       "Sustainable Cities and Communities",                                                                   "Access to green spaces",
  "11.a",       "Sustainable Cities and Communities",                                   "Improve links between urban, periurban and rural areas",
  "11.b",       "Sustainable Cities and Communities",                                      "More cities integrating policies toward inclusion",
  "11.c",       "Sustainable Cities and Communities",                                                      "Sustainable and resilient buildings",
  "12.1",   "Responsable Consumption and Production",                         "Implement the framework of programmes on sustainable consumption",
  "12.2",   "Responsable Consumption and Production",                                                       "Efficient use of natural resources",
  "12.3",   "Responsable Consumption and Production",                                                                  "Halve global food waste",
  "12.4",   "Responsable Consumption and Production",                                                            "Sound management of chemicals",
  "12.5",   "Responsable Consumption and Production",                                                                  "Reduce waste generation",
  "12.6",   "Responsable Consumption and Production",                                                          "Encourage sustainable practices",
  "12.7",   "Responsable Consumption and Production",                                                 "Sustainable public procurement practices",
  "12.8",   "Responsable Consumption and Production",                                             "Ensure awareness for sustainable development",
  "12.a",   "Responsable Consumption and Production",                                      "Strengthen scientific and technological capacities",
  "12.b",   "Responsable Consumption and Production",                                      "Implement tools to monitor sustainable development",
  "12.c",   "Responsable Consumption and Production",                                            "Rationalize inefficient fossil-fuel subsidies",
  "13.1",                           "Climate Action",                                         "Strengthen resilience to climate-related hazards",
  "13.2",                           "Climate Action",                                      "Integrate clima change measure in national policies",
  "13.3",                           "Climate Action",                                    "Improve education regarding climate change mitigation",
  "13.a",                           "Climate Action",         "Implement the commitment of developed countries to support developing countries",
  "13.b",                           "Climate Action",                          "Raising capacity for effective climate change-related planning",
  "14.1",                         "Life below Water",                                                                  "Reduce marine pollution",
  "14.2",                         "Life below Water",                                                    "Protect marine and coastal ecosystems",
  "14.3",                         "Life below Water",                                                             "Minimize ocean acidification",
  "14.4",                         "Life below Water",                                                  "Regulate harvesting and end overfishing",
  "14.5",                         "Life below Water",                                        "Conserve at least 10% of coastal and marine areas",
  "14.6",                         "Life below Water",                                                       "Prohibit certain forms of fisherie",
  "14.7",                         "Life below Water",                                      "Increase benefit for small island developing states",
  "14.a",                         "Life below Water",                                     "Improve scientific knowledge to improve ocean health",
  "14.b",                         "Life below Water",                                   "Access for smallscale fishers to resources and markets",
  "14.c",                         "Life below Water",                                       "Enhance conservation and sustainable use of oceans",
  "15.1",                             "Life on Land",                                                        "Conservation of inland ecosystems",
  "15.2",                             "Life on Land",                                                            "Sustainable forest management",
  "15.3",                             "Life on Land",                                                                    "Restore degraded land",
  "15.4",                             "Life on Land",                                                      "Conservation of mountain ecosystems",
  "15.5",                             "Life on Land",                                       "Actions against degradation of natural habitats...",
  "15.6",                             "Life on Land",                        "Sharing of the benefits arising from the use of genetic resources",
  "15.7",                             "Life on Land",                                                             "End poaching and trafficking",
  "15.8",                             "Life on Land",                                                    "Reduce the impact of invasive species",
  "15.9",                             "Life on Land",                                          "Integrate ecosystem values to national planning",
  "15.a",                             "Life on Land",                                            "Increase financial resources for conservation",
  "15.b",                             "Life on Land",                           "Increase financial resources for sustainable forest management",
  "15.c",                             "Life on Land",                       "Improve local living conditions to reduce poaching and trafficking",
  "16.1",   "Peace, Justice and Strong Institutions",                                                          "Reduce violence and death rates",
  "16.2",   "Peace, Justice and Strong Institutions",                                               "End all forms of violence against children",
  "16.3",   "Peace, Justice and Strong Institutions",                                                                  "Equal access to justice",
  "16.4",   "Peace, Justice and Strong Institutions",                                              "Reduce illicit financial and arm flows, ...",
  "16.5",   "Peace, Justice and Strong Institutions",                                                                        "Reduce corruption",
  "16.6",   "Peace, Justice and Strong Institutions",                                                   "Effective and transparent institutions",
  "16.7",   "Peace, Justice and Strong Institutions",                                                               "Responsive decision making",
  "16.8",   "Peace, Justice and Strong Institutions",                       "Strengthen position of developing countries in global institutions",
  "16.9",   "Peace, Justice and Strong Institutions",                                                                           "Legal identity",
  "16.10",   "Peace, Justice and Strong Institutions",                                                                   "Access to information",
  "16.a",   "Peace, Justice and Strong Institutions",                                            "Strengthen relevant national institutions,...",
  "16.b",   "Peace, Justice and Strong Institutions",                                                          "Promote non discriminatory laws",
  "17.1",                "Partnership for the goals",                                                "Strengthen domestic resource mobilization",
  "17.2",                "Partnership for the goals", "Developed countries to implement fully their official development assistance commitments",
  "17.3",                "Partnership for the goals",                                                  "Mobilize additional financial resources",
  "17.4",                "Partnership for the goals",                                                                 "Attaining long term debt",
  "17.5",                "Partnership for the goals",                                                             "Investment promotion regimes",
  "17.6",                "Partnership for the goals",                                                     "Enhance international cooperation...",
  "17.7",                "Partnership for the goals",                                              "Dissemination of environmental technologies",
  "17.8",                "Partnership for the goals",                                               "Enhance the use of enabling technology,...",
  "17.9",                "Partnership for the goals",                                     "Enhance international support for SDG implementation",
  "17.10",                "Partnership for the goals",                                                              "Multilateral trading system",
  "17.11",                "Partnership for the goals",                                                 "Increase exports of developing countries",
  "17.12",                "Partnership for the goals",                                                            "Duty/quota free market access",
  "17.13",                "Partnership for the goals",                                                           "Global macroeconomic stability",
  "17.14",                "Partnership for the goals",                                     "Enhance policy coherence for sustainable development",
  "17.15",                "Partnership for the goals",                                 "Respect country's policy space for povertity eradication",
  "17.16",                "Partnership for the goals",                  "Enhance multistakeholder partnerships to support the achievement of SDG",
  "17.17",                "Partnership for the goals",                                    "Promote public private public and civil partnerhships",
  "17.18",                "Partnership for the goals",                                            "Capacity building for high data availabilitiy",
  "17.19",                "Partnership for the goals",                              "Develop measurements of progress on sustainable development"
)


# THIS DOES NOT WORK ON SHINYAPP SERVER
# Download the data from the online-sheet and load
#drive_download(as_id("1CXGo4Zh8i7R4aLlCmdqKbNr9qH5xeH9Lq2h3-UMqWh4"),type = "csv",overwrite = TRUE)

# OTHER APPROACH
download.file(url = "https://docs.google.com/spreadsheets/d/1CXGo4Zh8i7R4aLlCmdqKbNr9qH5xeH9Lq2h3-UMqWh4/export?format=csv",
              destfile = "sources.csv")

tb_sdg<-read.csv("sources.csv", stringsAsFactors = FALSE)

# Replace NAs by empty values
tb_sdg[is.na(tb_sdg)] <- ""

# Concatenate targets
tb_sdg <- tb_sdg %>%
  unite("target", starts_with("Which.target"), sep = "")


### get all lsms surveys from catalog from https://microdata.worldbank.org/index.php/catalog/lsms
#create function which downloads surveys from all nine pages
get_lsms <- function(urls, selector){
  lsms_page <- read_html(urls)
  temp <- html_text(html_nodes(lsms_page, selector))
}

#get selector via the Selector gadget

selector <- ".study-country , .title a"
#list all necessary urls
pages <- paste0("https://microdata.worldbank.org/index.php/catalog/?ps=15&view=s&from=1890&to=2018&collection[]=lsms&page=", 1:9)
#get all surveys
lsms <- map2(pages, selector, get_lsms)

lsms_df <- paste(lsms, collapse= " ") %>%
  str_replace_all('\\", \\"\\\\r\\\\n', "") %>%
  str_replace_all('\\", \\n\\"\\\\r\\\\n', "") %>%
  str_replace_all('\\"\\\\r\\\\n', "") %>%
  str_replace_all('c\\(', "") %>%
  str_replace_all('\\"\\)',"") %>%
  str_replace_all('\\"\\n\\)',"") %>%
  str_split(",[:blank:]+[:digit:]{4}[:punct:]?[:digit:]*") %>%
  as_vector() 

lsms_df <- lsms_df[!str_detect(string = lsms_df, pattern = "^[:blank:]+$")] %>%
  as_tibble() %>%
  mutate(survey = str_extract(value, pattern = "[[:alpha:]+[:space:]]+")) %>%
  mutate(year = str_extract(value, pattern = "[:digit:]{4}[[:punct:][:digit:]{4}]*")) %>%
  mutate(Which.countries.are.covered..1 = str_extract(value, pattern = "[[:alpha:][:space:]]*[:graph:]*$")) %>%
  mutate(Start = str_extract(year, pattern = "[:digit:]{4}")) %>%
  mutate(End = str_extract(year, pattern = "[:digit:]{4}($|(?=.{0,3}$))")) %>%
  select(survey, Which.countries.are.covered..1, Start, End)


#### get links to survey site

##get hyperlinks
lsms_href <- function(urls, selector){
  lsms_page <- read_html(urls)
  temp <- html_nodes(lsms_page, selector) %>%
    html_attr("href")
}

#define new selector
selector = ".title a"

#get urls
url_ <- map2(pages, selector, lsms_href) 

links <- paste(url_, collapse = ",") %>%
  str_split(",") %>%
  as_vector() %>%
  str_replace_all("c\\(", "")
links <- links[str_detect(links, "https:")] %>% 
  as_tibble()

lsms_df <- cbind(lsms_df, links) 
lsms_df <- mutate(lsms_df, link = paste0("<a href=", trimws(value), ">", survey, "</a>")) %>%
  select(survey, Which.countries.are.covered..1, Start, End, link)

#replace country names of lsms survey with the ones used in the app (countries lsms)
lsms_df$`Which.countries.are.covered..1` <- lsms_countries$app_countries

#####add source to tb_sdg
#prepare list with country names who attended  lsms-isa
lsms_isa <- c("Burkina Faso","Ethiopia", "Malawi", "Mali", "Niger", "Nigeria","Tanzania", "Uganda" )
lsms_isa_df <- lsms_df %>% 
  filter(Which.countries.are.covered..1 %in% lsms_isa, Start >= 2008) %>%
  mutate(Source = "LSMS-ISA")

#populates survey-country-date from IHSN with google sheet info
src_replace <- tb_sdg %>%
  filter(Source %in% lsms_isa_df$Source) %>%
  select(-Which.countries.are.covered..1, -Start, -End)%>%
  full_join(lsms_isa_df, by = "Source") %>%
  mutate(Source = survey,
         Access = link) %>%
  select(-survey,-link)

# #convert tb_sdg$End to character
# tb_sdg$End <- as.character(tb_sdg$End)

#convert src_source to integer
src_replace$End <- as.numeric(src_replace$End)


# Deletes the generic sources from tb_sdg
# and replaces with detailed sources from LSMS-ISA
tb_sdg <- tb_sdg %>%
  filter(!(Source %in% lsms_isa_df$Source)) %>%
  bind_rows(src_replace)


##########load list of prepared datasets (MICS,...)
#load list of prepared datasets (MICS,...)
# Script by FB to prepare the list of available datasets 
# and load them into locateSDG

# Tidyverse style!


# Download all available surveys and census from ihsn (max = 20K, actual ~6K)
download.file(url = "http://catalog.ihsn.org/index.php/catalog/export/csv?ps=20000&collection[]=",
              destfile = "ihsn.csv")

# Load the data
ihsn <- read_csv("ihsn.csv")

# strings/patterns in survey titles that are characteristics to survey type
dhs_str <- "Demographic and Health Survey|D.mographique et de Sant.|Demograf.a y Salud|Demografia e Sa.de|National Family Health Survey"
mics_str <- "Multiple Indicator|Indicadores M.ltipl|Indicateurs Multiples"

# columns selecting surveys according to survey type
ihsn_src <- ihsn %>%
  mutate(Source = "",
         Source = ifelse(str_detect(title, dhs_str), "Demographic and Health Survey (DHS)", Source),
         Source = ifelse(str_detect(title, mics_str), "Multiple Cluster Indicator Survey (MICS)", Source),
         Source = ifelse(str_detect(title, "Census") & 
                           !str_detect(title, "Agric|Econom|Livestock|Establ|School|Microfi|Insustr|Facilit"),
                         "Population Census", Source)) %>% 
  # TODO: add new classes matching the added patterns (Afrobarometer, LSMS...)
  #convert country names to the ones used in googlespreadsheet
  left_join(ihsn_countries, by = c("nation" = "ihsn_cnames")) %>%
  filter(Source != "") %>%
  select(Which.countries.are.covered..1 = gspread,
         Start = year_start,
         End = year_end,
         Source,
         title_svy = title)%>%
  unique()

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


# Fill-in countries if global
n_max_country <- nrow(geo_tags)

country_vars <- paste0("country_", 1:n_max_country)
to_keep <- colnames(tb_sdg)
geo_tags_sel <- select(geo_tags, -region)
tb_sdg2 <- tb_sdg %>% 
  #separate continents
  separate_rows(Which.continents.are.covered.) %>%
  left_join(geo_tags_sel, by = c("Which.continents.are.covered." = "continent"))%>%
  # filling countries if only global or continent
  mutate(country_init = `Which.countries.are.covered..1`,
         country_init = ifelse(`Geographic.coverage` == "Global",
                               paste(geo_tags$country, collapse = ","), 
                               country_init),
         country_init = ifelse(`Geographic.coverage` == "Continental",
                               paste(country),
                               country_init)) %>%
  select(-country) %>%
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

# save(tb_sdg2, file = "tb_sdg2.Rdata")

# create the ui

#define textstyle
style_text <- "font-family: 'calibri'; font-size: 16pt"

# load("tb_sdg2.Rdata")

# create the UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage(
    "SDG Locator",
    # Panel of database
    tabPanel(
      "Explore the Data",
      
      wellPanel(h4("Filter SDG's"),
                fluidRow(
                  id = "form",
                  useShinyjs(),
                  div(
                    column(
                      2,
                      offset = 0,
                      
                      selectInput(
                        "goal",
                        "Goal",
                        choices = c("any", levels(tb_sdg2$Goal)),
                        selected = c("any")
                      ),
                      actionButton("reset", "Reset")
                    ),
                    column(2, offset = 0,
                           selectInput("target",
                                       "Target:",
                                       choices = NULL)),
                    
                    column(
                      2,
                      offset = 0,
                      selectInput(
                        "country",
                        "Country:",
                        choices = c("any", sort(unique(tb_sdg2$Country))),
                        selected = c("any")
                      )
                    ),
                    column(
                      5,
                      offset = 1,
                      sliderInput(
                        "timeline",
                        "Timeline:",
                        min = 1990,
                        max = as.numeric(format(Sys.Date(), "%Y")),
                        value = c(1990, as.numeric(format(Sys.Date(
                        ), "%Y"))),
                        sep = ""
                      )
                    ),
                    uiOutput("themesControl")
                  )
                )),
      fluidRow(
        column(6, offset = 0,
               wellPanel(
                 # Data
                 h3('Datasets', align = "center"),
                 dataTableOutput(outputId = "dTable")
               )),
        # end of "Dataset" tab panel
        column(5, offset = 1,
               wellPanel(
                 h3('Details', align = "center"),
                 DT::dataTableOutput("longtable")
               )) # end of "Visualize the Data" tab panel
      )
    )
    ,
    
    # about panel
    tabPanel("About",
             mainPanel(width= 8,
                       
                       h2('About SDGlocatoR'),
                       br(),
                       div(tags$b("The goals:"), " The ",
                           a(href = "https://www.un.org/sustainabledevelopment/sustainable-development-goals",
                             "Sustainable Development Goals"),                                    
                           "are the common objective and indicator
                           humanity decided to share to achieve a better 
                           and more sustainable future for all. They form 
                           a blueprint all States, funders, NGOs and 
                           private actors agreed upon to design their 
                           policies, monitor and report on."),
                       br(),
                       div(tags$b("The challenge:"),
                           " there are as many as 232 standard SDG 
                           indicators and most of them are only 
                           calculated at national level and every 
                           several years. Development practitioners 
                           need to identify the relevant measures and 
                           to monitor them with a higher frequency 
                           and at a local level."),
                       br(),
                       div(tags$b("A piece of the solution:"),
                           " This application was developed by the 
                           Agence Française de Développement (AFD) 
                           and the KfW Development Bank evaluation 
                           departments. It aims at helping development 
                           professionals, scientists and citizens to 
                           identify available data sources to better 
                           understand and describe the development 
                           challenges, trends and impact. For every 
                           SDG target, it provides a list of 
                           continuously updated data sources, and 
                           orients the user on how to get and 
                           analyze this data."),
                       br(),
                       div(tags$b("How to use this app:"),
                           " just select your country of interest, 
                           the Sustainable Development Goal you are 
                           addressing and the period you want 
                           information from.  You will find a list 
                           of available data sources. For each data 
                           sources, the tab 'Selected indicator' 
                           provides more information on how to obtain 
                           the data and how to process it to 
                           calculate your area of interest."),
                       br(),
                       div(tags$b("Contribute:"),
                           " You can help developing this application 
                           by helping developing its code via ",
                           a(href = "https://github.com/s5joschi/sdg",
                             "Github"), 
                           " or by submitting new data sources using ",
                           a(href = "https://docs.google.com/forms/d/e/1FAIpQLSdrsBRcXQZ1RXlfBXWT8CTDuKZ0-2jT9H_4RsO1p2qVCwnbnQ/viewform",
                             "this Online Form"), 
                           "."),
                       br(),
                       div(tags$b("Contact:"),
                           " for further questions, please open 
                           issues on the github repository of 
                           the application (link above).")  
                       )
                       )
                       )
                       )

# load("tb_sdg2.Rdata")

# load the filter function
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
  tb_sdg2<-tb_sdg2[,c("Goal", "Target", "Name", "Source", "Country", "Start", "End")]
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
                                     options = list(pageLength = 25), rownames = FALSE)
  
  
  #show selected rows in other table
  tb_sdg2_selected <- reactive({
    ids <- input$dTable_rows_selected
    t(mylongtable()[ids,])
  })
  
  
  
  output$longtable <- DT::renderDataTable({tb_sdg2_selected()}, escape = FALSE, server = TRUE,
                                          options = list(pageLength = 25, dom = 't'), selection = "none", colnames = "")
}

options = list(sDom  = '<"top">flrt<"bottom">ip')

# create the app
shinyApp(ui=ui,server = server)
