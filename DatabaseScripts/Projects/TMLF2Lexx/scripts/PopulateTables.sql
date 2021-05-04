﻿--Only for testing purposes

DROP TABLE tmpNR2
DROP TABLE tmpNR

SELECT * 
INTO tmpNR2
FROM DMS_RESTORED_DAILY2.DBO.TBLNACHAREGISTER2
WHERE COMMRECID = 33
AND NACHAFILEID = -1
AND ACCOUNTNUMBER = (SELECT ACCOUNTNUMBER FROM DMS_RESTORED_DAILY2.DBO.TBLCOMMREC WHERE COMMRECID = 33)

SELECT * 
INTO tmpNR
FROM DMS_RESTORED_DAILY2.DBO.TBLNACHAREGISTER
WHERE NACHAFILEID IS NULL
AND ACCOUNTNUMBER = (SELECT ACCOUNTNUMBER FROM DMS_RESTORED_DAILY2.DBO.TBLCOMMREC WHERE COMMRECID = 33)

Update tmpNR set amount = amount+(1+floor(10*RAND(8)))

TRUNCATE TABLE tblTMLF2TSLF
INSERT INTO tblTMLF2TSLF (TransactionDate, TransactionType, TransactionAmount, BalanceDue, createdby) values ('01/01/2014','Monthly Installment',1027*(RAND(128)),1207*(RAND(148)), 311)

TRUNCATE TABLE tblTMLF2LEXX
INSERT INTO tblTMLF2LEXX (TransactionDate, TransactionType, TransactionAmount, BalanceDue, createdby) values ('01/01/2014','Monthly Installment',10027*(RAND(118)),10207*(RAND(198)), 311)
