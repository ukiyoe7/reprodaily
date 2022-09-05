## TABELA DE PREÇOS 
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)
library(lubridate)
library(googlesheets4)
con2 <- dbConnect(odbc::odbc(), "reproreplica")



tabprecos2 <- dbGetQuery(con2,"
           WITH PRECO AS(SELECT PROCODIGO,PREPCOVENDA,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1)
           
           SELECT PD.PROCODIGO,
                       PRODESCRICAO,
                         GR1CODIGO,
                          TPLCODIGO,
                           MARCODIGO,
                            PROTIPO,
                             PREPCOVENDA,
                              PREPCOVENDA2,
                               PREPCOVENDA*2 PAR_ATC,
                                PREPCOVENDA2*2 PAR_LAB
           FROM PRODU PD
           INNER JOIN PRECO P ON PD.PROCODIGO=P.PROCODIGO
           WHERE GR1CODIGO<>17 AND PROSITUACAO='A'
           AND PROCODIGO2 IS NULL
           ") 

View(tabprecos2)