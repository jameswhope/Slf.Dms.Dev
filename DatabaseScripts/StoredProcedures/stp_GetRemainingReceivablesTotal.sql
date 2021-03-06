/****** Object:  StoredProcedure [dbo].[stp_GetRemainingReceivablesTotal]    Script Date: 11/19/2007 15:27:15 ******/
DROP PROCEDURE [dbo].[stp_GetRemainingReceivablesTotal]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetRemainingReceivablesTotal]
	(
		@CommRecId int
	)

as

SELECT 
	((-tblRegister.Amount
		-(SELECT 
			case when SUM(b.Amount) is null then 0 else sum(b.amount) end
		FROM 
			tblRegisterPayment b
		WHERE 
			b.FeeRegisterId=tblRegister.RegisterId
		)
	)
	* tblCommFee.[Percent]
	) as RemainingReceivables
INTO
	#tmp
FROM
	tblRegister INNER JOIN 
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
	tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
	tblAgency ON tblClient.AgencyId=tblAgency.AgencyId INNER JOIN
	tblCommScen ON tblClient.AgencyId=tblCommScen.AgencyId  INNER JOIN
	tblCommStruct ON tblCommScen.CommScenId=tblCommStruct.CommScenId INNER JOIN
	tblCommFee ON (tblRegister.EntryTypeId=tblCommFee.EntryTypeId AND tblCommFee.CommStructId=tblCommStruct.CommStructId)
WHERE
	tblCommStruct.CommRecId=@CommRecId AND
	tblEntryType.Fee=1

select 
	sum(remainingreceivables) as total 
from 
	#tmp 
where 
	remainingreceivables>0

drop table #tmp
GO
