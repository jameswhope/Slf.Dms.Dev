IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetDataForLetter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetDataForLetter
	END

GO

CREATE Procedure stp_NonDeposit_GetDataForLetter
@nondepositletterid int
AS
Select 
l.nondepositletterid,
l.lettertype,
n.nondepositid,
n.clientid,
n.matterid,
DueDate = Case When r.registerid is not null Then r.transactiondate 
			Else 
				Case When rp.replacementid is not null 
					then rp.depositdate
					Else n.misseddate
					End	
			End, 
CheckFee = isnull(rs.ChargeFee,0),
bouncedreasonid = r.bouncedreason,
l.registerid
from
tblnondepositletter l
inner join tblnondeposit n on n.nondepositid = l.nondepositid
left join tblregister r on r.registerid = l.registerid
left join tblnondepositreplacement rp on rp.replacementid = l.replacementid
left join tblbouncedreasons rs on rs.bouncedid = r.bouncedreason
where l.nondepositletterid = @nondepositletterid

GO

 

