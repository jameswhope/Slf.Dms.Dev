/****** Object:  StoredProcedure [dbo].[stp_GetPhonesForCreditor]    Script Date: 11/19/2007 15:27:13 ******/
DROP PROCEDURE [dbo].[stp_GetPhonesForCreditor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_GetPhonesForCreditor]
	(
		@creditorid int
	)

as

select
	tblcreditorphone.creditorphoneid,
	tblphone.*,
	tblphonetype.[name] as phonetypename,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblphone inner join
	tblcreditorphone on tblphone.phoneid = tblcreditorphone.phoneid inner join
	tblphonetype on tblphone.phonetypeid = tblphonetype.phonetypeid left outer join
	tbluser as tblcreatedby on tblphone.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblphone.lastmodifiedby = tbllastmodifiedby.userid
where
	tblcreditorphone.creditorid = @creditorid
order by
	tblphonetype.[name]
GO
