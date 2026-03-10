## SUMMATIVE HEALTH INFORMATICS AND CLINICAL INTELLIGENCE

#libraries
# Loading
library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)
library(tidyr)
library(ineq)

## ---- Total number of teenage pregnancies ----


#import the datasets


##----LOAD DATA SETS ----
fndataENWAL <- read_excel(".../birthRateENWAL.xlsx", sheet="Table_2")
fndataMEX <-read_excel(".../birthRateMEX.xlsx")
fndataSCT<-read_excel(".../birthsScotland.xlsx", sheet="2.2")
fndataNI<-read_excel(".../BrithsNorthernIreland.xlsx", sheet="Table 3.3")
fndataEurope <- read_excel(".../birthEuropeUnder20.xlsx", sheet="Data (table)")
fndataBrazil <-read_excel(".../Brazil.xlsx")
fndataChile <-read_excel(".../Chile.xlsx", sheet="Cuadro 2")
fndataColombia <-read_excel(".../Colombia.xlsx", sheet="Cuadro1")
fndataPeru <-read_excel(".../Peru.xlsx", sheet="C1")
fndataUruguay <-read_excel(".../Uruguay.xlsx", sheet="2.3.5")
fndataRD <-read_excel(".../RD.xlsx", sheet="Cuadro 1.10.3")
fndataPanama <-read_excel(".../Panama.xlsx", sheet="Sheet1")


#----SOURCES----
# COUNTRY (ORGANIZATION) -> LINK

# MEXICO (INEGI) - >  https://www.inegi.org.mx/app/tabulados/interactivos/?pxq=Natalidad_Natalidad_02_e2497dbe-f31a-4743-b2ec-ecb13e1a24a2
# ENGLAND AND WALES (ONS) -> https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/birthsummarytables
# SCOTLAND (PUBLIC HEALTH SCOTLAND) -> https://publichealthscotland.scot/publications/births-in-scotland/births-in-scotland-year-ending-31-march-2024/
# NORTHERN IRELAND (NISRA) -> https://www.nisra.gov.uk/statistics/births-deaths-and-marriages/registrar-general-annual-report
# EUROPE (WHO) -> https://gateway.euro.who.int/en/indicators/hfa_593-7041-number-of-all-live-births-to-mothers-aged-under-20-years/#id=19688
# BRAZIL (IBGE) ->https://www.ibge.gov.br/estatisticas/sociais/populacao/9110-estatisticas-do-registro-civil.html 
# COLOMBIA (DANE) -> https://www.dane.gov.co/index.php/estadisticas-por-tema/salud/nacimientos-y-defunciones/nacimientos/nacimientos-2022
# PERU (INEI) -> https://www.gob.pe/institucion/inei/informes-publicaciones/4718062-peru-nacidos-vivos-de-madres-adolescentes-2019-2022 
# CHILE (INE) -> https://www.ine.gob.cl/estadisticas/sociales/demografia-y-vitales/nacimientos-matrimonios-y-defunciones 
# URUGUAY (INE) -> https://www.gub.uy/instituto-nacional-estadistica/comunicacion/publicaciones/anuario-estadistico-nacional-2023-volumen-n-100/23-indicadores-3
# DOMINICAN REPUBLIC (ONE) -> https://www.one.gob.do/datos-y-estadisticas/temas/estadisticas-demograficas/estadisticas-vitales/
# PANAMA (INEC) -> https://www.inec.gob.pa/publicaciones/Default3.aspx?ID_PUBLICACION=1218&ID_CATEGORIA=3&ID_SUBCATEGORIA=6
# **ECUADOR (INEC) -> https://www.igualdad.gob.ec/wp-content/uploads/downloads/2024/08/boletin_estadistico_embarazo_adolescente_20240722.pdf 

# ** Had to create a data set with the values given in the link, since the data set could not be found.

#----

##Organize table of data sets:

## names for columns
name1 <- "Year"
name2 <- "All ages Live births"
name3<- "Under 20 Live births"

#dataENWAL new data set from fndataENWAL, new column names and organization

birthsENWAL <- fndataENWAL %>%
  rename_with(~c(name1,name2,name3), c(1,2,3)) %>%  ##rename columns with appropriate names
  filter(!row_number() %in% c(1:7)) %>%       #delete rows that aren't necessary
  select(-(4:15)) %>%                     ## delete columns 4 to 15
  mutate_at(c(name2,name3), as.numeric)  %>%  #convert chr to number
  filter(Year == 2022)   #delete rows from years we dont need

birthsENWAL <- birthsENWAL %>% 
  select(1,2,3) %>% 
  mutate(
    Place = "England and Wales"
  ) 

#data SCOTLAND
birthsSCT <- fndataSCT %>% 
  filter(row_number() %in% c(20)) %>%       #delete rows that aren't necessary
  select(1,3,4) %>% 
  rename(
    Place = ...1,
    "All ages Live births"= ...3,
    "Under 20 Live births" = ...4
  ) %>% 
  mutate(
    Year = 2022
  ) %>% 
  relocate (4, .before = 1) %>% 
  relocate(2, .after = 4)

#data Northern Ireland
birthsNI <- fndataNI %>% 
  filter(row_number() %in% c(53)) %>% 
  select(1:2,6:10) %>% 
  mutate(
    across(where(is.character), as.numeric),
    "Under 20 Live births" = ...6+...7+...8+...9+...10
  ) %>% 
  rename(
    Year = `Table 3.3 Live births by Mother's Age, 1974 to 2022`,
    "All ages Live births"= ...2,
  )

birthsNI<- birthsNI %>%  
  select(1,2,8) %>% 
  mutate(Place = "Northern Ireland") 


#Create data UK
bindBirthsUK <- rbind(birthsENWAL,birthsNI,birthsSCT) 

birthsUK <- bindBirthsUK %>% 
  summarise(
    Place = "UK",
    `All ages Live births`= sum(as.numeric(`All ages Live births`),na.rm=TRUE),
    `Under 20 Live births` = sum(as.numeric(`Under 20 Live births`),na.rm=TRUE)
  )

birthsUK <- birthsUK %>% 
  mutate(
    Year = 2022,
    `Percentage of births` = 100*(`Under 20 Live births`/`All ages Live births`)
  ) %>% 
  select(-(2:3)) %>% 
  relocate(2, .before=1)


#dataMEX new data set from fndataMEX, new column names and organization


birthsMEX <- fndataMEX %>% 
  filter(!row_number() %in% c(1:6,8:18)) %>%#delete unimportant rows
  select(-(2:13)) %>% 
  rename('2022' = ...14) %>% 
  pivot_longer(cols=as.character(2022), names_to="Year") %>%  ##change rows to column
  pivot_wider(names_from="Instituto Nacional de Estadística y Geografía (INEGI)") %>% 
  rename(`Percentage of births` = 'Estados Unidos Mexicanos') %>% 
  mutate(Place = "Mexico")  

birthsMEX <- birthsMEX %>% 
  relocate (3, .before=2) 



## clean data, select countries we want from europe
## create column to assign the total number of births in 2022
#to compute the percentage birth column
# data set from europe had no total births of all group ages
# had to compute an extra column with total births to calculate the percentage
# the source of every number of total births below, is the comment next to the number


birthsEurope <- fndataEurope %>% 
  filter(YEAR == 2022) %>% 
  filter(COUNTRY_REGION %in% c("ESP", "DEU","NLD", "CHE",
                               "BEL","ITA", "PRT", "NOR","SWE")) %>% 
  select(-(1:2)) %>% 
  mutate(TotalBirths = case_when(
    COUNTRY_REGION == "ESP" ~ 329251,      #SPAIN (INE) https://www.ine.es/consul/serie.do?d=true&s=MNP162 
    COUNTRY_REGION == "DEU" ~ 738819,      #GERMANY (DESTATIS) https://www.destatis.de/EN/Themes/Society-Environment/Population/Births/Tables/lrbev04.html#242410
    COUNTRY_REGION == "NLD" ~ 167504,      #NETHERLANDS (CBS) https://www.cbs.nl/en-gb/visualisations/dashboard-population/population-dynamics/birth
    COUNTRY_REGION == "CHE" ~ 82371,       #SWITZERLAND (BFS) https://www.bfs.admin.ch/bfs/en/home/statistics/population/births-deaths.html 
    COUNTRY_REGION == "BEL" ~ 113593,      #BELGIUM (STATBEL) https://statbel.fgov.be/en/themes/population/natality-and-fertility#:~:text=With%20113%2C593%20births%20in%202022,with%20a%20decrease%20of%203%25. 
    COUNTRY_REGION == "ITA" ~ 393333,      #ITALY (I.STAT) http://dati.istat.it/Index.aspx 
    COUNTRY_REGION == "PRT" ~ 83671,       #PORTUGAL (INE) https://www.ine.pt/xportal/xmain?xpid=INE&xpgid=ine_indicadores&indOcorrCod=0008234&contexto=bd&selTab=tab2 
    COUNTRY_REGION == "NOR" ~ 51480,       #NORWAY (SSB) https://www.ssb.no/en/befolkning/fodte-og-dode/statistikk/fodte 
    COUNTRY_REGION == "SWE" ~ 104734,      #SWEDEN (SCB) https://www.statistikdatabasen.scb.se/pxweb/sv/ssd/START__BE__BE0101__BE0101G/ManadFoddDod/?rxid=acb77812-5919-4ad6-8695-c9c6b862980c 
  )) %>% 
  rename(Place = COUNTRY_REGION) %>% 
  rename(Year = YEAR) 



birthsEurope$PercentageOfBirthEU = (birthsEurope$VALUE/birthsEurope$TotalBirths)*100

birthsEurope <- birthsEurope %>% 
  select(-(3:4)) %>% 
  relocate (1, .before=3) %>% 
  rename(`Percentage of births` = PercentageOfBirthEU) %>% 
  mutate(Place = recode(Place, "ESP" = "Spain", "DEU"="Germany",
                        "NLD" = "Netherlands", "CHE" = "Switzerland",
                        "BEL" = "Belgium", "ITA" = "Italy",
                        "PRT" = "Portugal", "NOR" = "Norway",
                        "SWE" = "Sweden"))




## MORE EUROPEAN COUNTRIES EAST EUROPE
birthsEastEurope <- fndataEurope %>% 
  filter(YEAR == 2022) %>% 
  filter(COUNTRY_REGION %in% c("BGR", "CZE","KZA", "SRB",
                               "SVK","TUR")) %>% 
  select(-(1:2)) %>% 
  mutate(TotalBirths = case_when(
    COUNTRY_REGION == "BGR" ~ 56892,      #BULGARIA (NSI) https://www.nsi.bg/sites/default/files/files/pressreleases/Population2022_en_3C3NKZD.pdf
    COUNTRY_REGION == "CZE" ~ 101299,     #CZECH REPUBLIC (CSU) https://csu.gov.cz/births?pocet=10&start=0&podskupiny=133&razeni=-datumVydani
    COUNTRY_REGION == "KZA" ~ 359812,     #KAZAKHSTAN (UN) https://www.macrotrends.net/global-metrics/countries/KAZ/kazakhstan/population
    COUNTRY_REGION == "SRB" ~ 62700,      #SERBIA (PBC) https://www.stat.gov.rs/en-US/vesti/statisticalrelease/?p=14058
    COUNTRY_REGION == "SVK" ~ 56178,      #SLOVAKIA (UN) https://www.macrotrends.net/global-metrics/countries/rou/slovakia/population
    COUNTRY_REGION == "TUR" ~ 1035795,    #TURKEY (TUIK) https://data.tuik.gov.tr/Bulten/Index?p=Birth-Statistics-2022-49673
    
  )) %>% 
  rename(Place = COUNTRY_REGION) %>% 
  rename(Year = YEAR) 


birthsEastEurope <- birthsEastEurope %>% 
  mutate(`Percentage of births` = (VALUE/TotalBirths)*100 ,
         Place = recode(Place, "BGR" = "Bulgaria", "CZE"="Czech Republic",
                        "KZA" = "Kazakhstan", "SRB" = "Serbia",
                        "SVK" = "Slovakia", "TUR" = "Turkey")) %>% 
  relocate(2, .before=1) %>% 
  select(-c(3,4))




## clean up data for latin american countries

#First, Brazil
birthsBrazil <- fndataBrazil %>% 
  filter(!row_number() %in% c(1:2,4:5)) %>% 
  select(-c(2,4:11)) %>% 
  rename(
    Place = 'Percentual de nascidos vivos por idade da mãe no parto',
    UnderFifteen = '...12',
    FifteenToNineteen = '...3'
  ) %>% 
  mutate(
    FifteenToNineteen= as.numeric(gsub(",", ".", FifteenToNineteen)),
    UnderFifteen = as.numeric(gsub(",", ".", UnderFifteen)),
    `Percentage of births` = UnderFifteen + FifteenToNineteen
  )



#BRAZIL
birthsBrazil <- birthsBrazil %>% 
  mutate(
    Year = 2022) %>% 
  select(-c(2,3)) %>% 
  relocate (3, .before=1) %>% 
  mutate(Place = recode(Place, "Brasil" = "Brazil"))

#COLOMBIA
#delete columns and rows we dont need, transform rows to columns
#compute additional column for percentage of births and place
birthsColombia <- fndataColombia %>% 
  filter(!row_number() %in% c(1:6,10:21)) %>% 
  select(-c(3:17)) %>% 
  rename(Value = ...2) %>% 
  pivot_wider(names_from= `Estadísticas vitales de nacimientos y defunciones`, values_from=Value) %>% 
  
  mutate(
    across(where(is.character), as.numeric),
    `Percentage of births` = ((`De 10-14 Años` + `De 15-19 Años`)/`Total Nacional`)*100,
    Place = 'Colombia',
    Year = 2022)

birthsColombia <- birthsColombia %>% 
  select(-c(1:3)) %>% 
  relocate (3, .before=1) %>% 
  relocate(2, .after=3)

##PERU DATA SET

birthsPeru <- fndataPeru %>% 
  rename(Year=`CUADRO Nº 01`,
         PercentageOfUnder15 = `...4`,
         PercentageOf15To19 = `...6`) %>% 
  select(-c(2,3,5)) %>% 
  filter(!row_number() %in% c(1:8,10:13)) %>% 
  mutate(
    across(where(is.character), as.numeric),
    `Percentage of births` = PercentageOf15To19 + PercentageOfUnder15,
    Place = 'Peru'
  )

##FINAL DATA SET FROM PERU
birthsPeru<-birthsPeru %>% 
  select(-c(2,3)) %>% 
  relocate(3, .before=2)



#DATA CHILE

birthsChile <- fndataChile %>% 
  select(-c(3:5)) %>% 
  filter(!row_number() %in% c(1:2,6:15)) %>% 
  pivot_wider(names_from= `Nacimientosp totales y por sexo, según grupo de edad de la madre. \r\n`, values_from=`...2` ) %>% 
  mutate(
    across(where(is.character), as.numeric),
    `Percentage of births` = ((`Menores de 15` + `15 a 19`)/`Total Pais`)*100,
    Place = 'Chile',
    Year = 2022
  )


#FINAL DATA FOR CHILE
birthsChile <- birthsChile %>% 
  select(-c(1:3)) %>% 
  relocate (3, .before=1) %>% 
  relocate(2, .after=3)


## URUGUAY

birthsUruguay <- fndataUruguay %>% 
  select(-c(2:7,9:12)) %>% 
  filter(!row_number() %in% c(1:5,7,15:49)) %>% 
  pivot_wider(names_from= `2.3.5 - Nacimientos, por año y sexo del recién nacido, según edad materna`, values_from=`...8` ) %>% 
  mutate(
    across(where(is.character), as.numeric),
    `Percentage of births` = ((`13`+`14`+`15`+`16`+`17`+`18`+`19`)/`Total`)*100,
    Place = 'Uruguay',
    Year = 2022
  )

birthsUruguay <- birthsUruguay %>% 
  select(-c(1:8)) %>% 
  relocate (3, .before=1) %>% 
  relocate(2, .after=3)

# DOMINICAN REPUBLIC

birthsRD <- fndataRD %>% 
  select(-c(5:12)) %>% 
  filter(row_number() %in% c(25)) %>% 
  rename_with(~make.names(.)) %>% 
  rename( Year = Cuadro.1.10.3..REPÚBLICA.DOMINICANA..Nacimientos.ocurridos.por.grupos.de.edades.de.la.madre.al.momento.del.nacimiento.del.hijo..a...según.año.de.ocurrencia..2001.2023.,
          Total = ...2,
          Under15 = ...3,
          FifteenToNineteen = ...4
  ) %>% 
  mutate(
    across(where(is.character), as.numeric),
    `Percentage of births` = ((Under15+FifteenToNineteen)/Total)*100,
    Place = 'Dominican Republic',
    Year = 2022
  )


#FINAL DATA SET DOMINICAN REPUBLIC
birthsRD <- birthsRD %>% 
  select(-c(2:4)) %>% 
  relocate (3, .before=2) 

## FINAL DATA SET PANAMA
birthsPanama <- fndataPanama %>% 
  rename(
    `Percentage of births` = Percentage,
    Year = YEAR) %>% 
  mutate(
    across(where(is.character), as.numeric),
    Place = "Panama"
  ) %>% 
  relocate (3, .before=2) 

#Create dataset for Ecuador

birthsEcuador <- data.frame(
  Year = 2022,
  Place = "Ecuador",
  `Percentage of births` = 16
)

birthsEcuador <- birthsEcuador %>% 
  rename(
    `Percentage of births`=Percentage.of.births
  )


## Bind the data frames
TeenBirths2022LATAM_EU <- rbind(birthsBrazil,
                                birthsColombia,
                                birthsPeru,
                                birthsChile,
                                birthsUruguay,
                                birthsRD,
                                birthsPanama,
                                birthsEcuador, birthsEurope,birthsMEX,birthsUK,birthsEastEurope) %>% 
  arrange(`Percentage of births`)



## LOAD HDI INDEX

HDIdata<-read.csv("/Users/anaca/OneDrive/Escritorio/2ndTerm/Health Informatics and Clinical Intelligence/Summative/HDI.csv")


HDIndexData <- HDIdata %>% 
  filter(country %in% c("Mexico", "Brazil","United Kingdom", "Spain",
                        "Germany","Italy", "Portugal", "Norway","Sweden",
                        "Netherlands", "Switzerland", "Belgium", "Colombia",
                        "Peru", "Chile", "Uruguay", "Dominican Republic",
                        "Panama", "Ecuador","Bulgaria",
                        "Czech Republic","Kazakhstan","Serbia","Slovakia",
                        "Turkey")) %>%
  select(-c(2,4:9)) 

TeenBirths2022_HDI <- merge(HDIndexData,TeenBirths2022LATAM_EU,
                            by.x="country",by.y="Place")  


##classify countries by region/subregion
TeenBirths2022_HDI <- TeenBirths2022_HDI %>% 
  mutate(Region = case_when(
    country == "Mexico" ~ "LATAM",
    country == "Brazil" ~ "LATAM",
    country == "Colombia" ~ "LATAM",
    country == "Peru" ~ "LATAM",
    country == "Chile" ~ "LATAM",
    country == "Uruguay" ~ "LATAM",
    country == "Dominican Republic" ~ "LATAM",
    country == "Panama" ~ "LATAM",
    country == "Ecuador" ~ "LATAM",
    country == "UK" ~ "W. Europe",
    country == "Spain" ~ "W. Europe",
    country == "Germany" ~ "W. Europe",
    country == "Italy" ~ "W. Europe",
    country == "Portugal" ~ "W. Europe",
    country == "Norway" ~ "W. Europe",
    country == "Sweden" ~ "W. Europe",
    country == "Netherlands" ~ "W. Europe",
    country == "Switzerland" ~ "W. Europe",
    country == "Belgium" ~ "W. Europe",
    country == "Bulgaria" ~ "E. Europe",
    country == "Czech Republic" ~ "E. Europe",
    country == "Kazakhstan" ~ "E. Europe",
    country == "Serbia" ~ "E. Europe",
    country == "Slovakia" ~ "E. Europe",
    country == "Turkey" ~ "E. Europe",
  ))




##CALCULATE SII
slope <- TeenBirths2022_HDI %>% 
  mutate(HDIdecile = ntile (Hdi2022, 10)) %>% 
  count(HDIdecile)

TeenBirths2022_HDI <- TeenBirths2022_HDI %>% 
  mutate(HDIdecile = ntile(((Hdi2022^-1)+0.01),10)) %>% ##transform HDI to have a positive plot
  left_join(slope, by ="HDIdecile" ) %>% 
  rename(decPopn = n)

TeenBirths2022_HDI$`Percentage of births` <- as.numeric(TeenBirths2022_HDI$`Percentage of births`)


slopeBirths <- TeenBirths2022_HDI %>% 
  group_by(HDIdecile) %>%
  summarise(
    birthRate = mean(`Percentage of births`),  #mean of percentage of births
    decPopn = n()                             #number of countries per decil
  ) %>%
  mutate(decileCentre = HDIdecile * 10 - 5)


BRmodel <- lm(log(birthRate)~decileCentre, slopeBirths, weights=decPopn) #log to improve linearity
BRslope = BRmodel$coefficients[["decileCentre"]]
BRintercept = BRmodel$coefficients[["(Intercept)"]]
BRat100 = BRintercept + 100 *BRslope
SII = BRat100 - BRintercept

ggplot(slopeBirths,  aes(x = decileCentre, y =log(birthRate))) + 
  geom_point() + 
  geom_abline(slope = BRslope, intercept = BRintercept) + 
  annotate("text", x = 15, y = -2,
           label = paste("Value at 0:", format(BRintercept, digits = 3)))+
  annotate("text", x=80, y = 4,
           label = paste("Value at 100:", format(BRat100, digits = 4 ))) +
  annotate("text", x= 60, y = 0,
           label = paste("SII:", format(SII, digits = 3))) + 
  scale_x_continuous(name = "0.01 + 1/HDI Decile (higher indicates a lower level of development)",
                     labels = function(x) {paste0(x)},
                     breaks = seq(0,100,20)) + 
  scale_y_continuous(name = "Percentage of Live Births of Teenage Women (log value)",
                     breaks = seq(-2,6,2)) + 
  theme_bw()


##PLOT FOR REGION AND PERCENTAGE OF BIRTHS
ggplot(TeenBirths2022_HDI, aes(x = `Percentage of births`, y = Region, fill=Region)) +
  geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) +
  labs(x = paste("Percentage of births in 2022"),
       y = "",
       caption = "Vertical lines are quartiles") +
  theme_minimal()




