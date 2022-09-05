
library(DBI)
library(dplyr)
con2 <- dbConnect(odbc::odbc(), "reproreplica")


## SELECT CLICODIGO FROM CLIEN WHERE GCLCODIGO=175

pedidos <- dbGetQuery(con2,"
    
   WITH CLI AS (SELECT DISTINCT C.CLICODIGO,
                         CLINOMEFANT,
                          ENDCODIGO,
                           GCLCODIGO,
                           SETOR
                            FROM CLIEN C
                             LEFT JOIN (SELECT CLICODIGO,
                                                E.ZOCODIGO,
                                                  ZODESCRICAO SETOR,
                                                   ENDCODIGO FROM ENDCLI E
                                                    LEFT JOIN (SELECT ZOCODIGO,
                                                                       ZODESCRICAO 
                                                                        FROM ZONA WHERE ZOCODIGO 
                                                                         IN (20,21,22,23,24,25,28))Z ON 
                                                                          E.ZOCODIGO=Z.ZOCODIGO 
                                                                           WHERE ENDFAT='S')A ON 
                                                                            C.CLICODIGO=A.CLICODIGO
                                                                             WHERE CLICLIENTE='S'),
                               
FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),
    
    PED AS (SELECT ID_PEDIDO,
                    TPCODIGO,
                     PEDDTEMIS,
                      PEDDTBAIXA,
                       P.CLICODIGO,
                        GCLCODIGO,
                         SETOR,
                          CLINOMEFANT,
                           PEDORIGEM
                            FROM PEDID P
                             INNER JOIN FIS ON P.FISCODIGO1=FIS.FISCODIGO
                              LEFT JOIN CLI C ON P.CLICODIGO=C.CLICODIGO AND P.ENDCODIGO=C.ENDCODIGO
                               WHERE PEDDTBAIXA BETWEEN '01.06.2022' AND '31.07.2022' 
                                AND PEDSITPED<>'C' AND 
                                 P.CLICODIGO IN (SELECT CLICODIGO FROM CLIEN WHERE GCLCODIGO=175))
    
    
      SELECT PD.ID_PEDIDO,
              TPCODIGO,
               PEDDTEMIS,
                PEDDTBAIXA,
                 CLICODIGO,
                  CLINOMEFANT,
                   GCLCODIGO,
                    SETOR,
                     PEDORIGEM,
                      FISCODIGO,
                       PROCODIGO,
                        PDPDESCRICAO,
                         PDPPCOUNIT,
                          SUM(PDPQTDADE)QTD,
                           SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
                            FROM PDPRD PD
                             INNER JOIN PED P ON PD.ID_PEDIDO=P.ID_PEDIDO
                              GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13 ORDER BY ID_PEDIDO DESC")  


View(pedidos)

