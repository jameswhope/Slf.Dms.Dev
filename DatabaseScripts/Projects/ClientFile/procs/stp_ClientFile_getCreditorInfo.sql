IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getCreditorInfo')
	BEGIN
		DROP  Procedure  stp_ClientFile_getCreditorInfo
	END

GO

CREATE Procedure stp_ClientFile_getCreditorInfo
(
@accountid int
)
as
BEGIN
	/*
	declare @accountid int
	set @accountid = 17292
*/
	select 
		[Current] = cc.name
		,[Original] = isnull(oc.name,'')
		,[AccountNumber] = isnull(ci.accountnumber,'')
		,[ReferenceNumber] = isnull(ci.referencenumber,'')
		,[DateAcquired] = isnull(ci.acquired,'')
		,[CurrentAmt] = isnull(ci.amount,'')
		,[OriginalAmt] = isnull(ci.originalamount,'')
		,[Address] = case when cc.street2 is null or cc.street2 = ''
		then isnull(cc.street,'') + char(13) + cc.city + ', ' + s.abbreviation + ' ' + cc.zipcode
		else isnull(cc.street,'') + char(13) + cc.street2 + char(13) + cc.city + ', ' + s.abbreviation + ' ' + cc.zipcode
		end
		
	from tblcreditorinstance ci
	inner join tblcreditor cc on cc.creditorid = ci.creditorid
	inner join tblstate s on s.stateid = cc.stateid
	left outer join tblcreditor oc on oc.creditorid = ci.forcreditorid
	where accountid = @accountid
	order by acquired

END

GRANT EXEC ON stp_ClientFile_getCreditorInfo TO PUBLIC


