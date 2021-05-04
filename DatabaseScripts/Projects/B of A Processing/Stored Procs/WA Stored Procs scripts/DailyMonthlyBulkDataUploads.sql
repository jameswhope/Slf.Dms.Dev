 --Daily transaction Journal 
BULK INSERT tblEMSDailyTransactionJournal
FROM 'g:\services\BofA\EMS\EMS_ACK_2010_09_14(3).dat'
WITH (
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n'
	  )

--Monthly Journal report
BULK INSERT tblEMSMonthlyBalances
FROM 'g:\services\BofA\EMS\EMS_ACK_2010_09_13(2).dat'
WITH (
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = ';\n'
	  )