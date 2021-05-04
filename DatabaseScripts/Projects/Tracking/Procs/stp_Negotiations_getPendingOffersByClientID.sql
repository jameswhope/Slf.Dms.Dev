IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Negotiations_getPendingOffersByClientID')
	BEGIN
		DROP  Procedure  stp_Negotiations_getPendingOffersByClientID
	END

GO

CREATE Procedure stp_Negotiations_getPendingOffersByClientID
	(
		@clientid int
	)
AS
BEGIN
select 
	negotiator
	,due
	,currentcreditor
	,originalcreditor
	,balance
	,settlementamt
	,settlementpercent
	,settlementfees
from 
	tblsettlementtrackerimports 
where 
	clientacctnumber in (select accountnumber from tblclient where clientid = @clientid)
	and paid is null 
	and canceldate is null 
	and expired is null
order by 
	due desc
END

GO


GRANT EXEC ON stp_Negotiations_getPendingOffersByClientID TO PUBLIC

GO


