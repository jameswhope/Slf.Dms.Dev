 
--*** add stored procs for ClientRequest functionalities   ****
--*** 0. Update function getentitydisplay
--*** 1. stp_InsertClientRequest ******
--*** 2. stp_GetClientRequestDetail ****
--*** 3. stp_GetClientRequestsbyClientId ****
--*** 4. stp_GetRelationForClientRequest ****
--*** 5. Update stp_GetRelatables ***
--*** Revision 1 1/21/2010 ****



--************ Update stp_GetRelatables *****
/*
      Revision    : <03 - 18 January 2010>
      Category    : [TimeMatter]
      Type        : {Update}
      Decription  : Added RelationTypeId=20 for ClientRequest 
*/

ALTER procedure [dbo].[stp_GetRelatables]
	(
		@relationtypeid int,
		@dependencyid int	--ClientID when relatable to client
							--CreditorID for contact
	)
as
declare @table varchar(50)


declare @select varchar(8000)
declare @join varchar(8000)
declare @where varchar(8000)

set @join=(select [table] from tblrelationtype where relationtypeid=@relationtypeid)

if @join='tblClient' begin
	set @join = @join + ' c inner join tblperson p on c.primarypersonid=p.personid'
	set @select = 'c.clientid as RelationID, p.firstname [First Name], p.LastName [Last Name], p.SSN'
	set @where = 'c.clientid=' + convert(varchar, @dependencyid)
end else if @join='tblAccount' begin
	set @join = @join + ' a inner join tblcreditorinstance ci on a.currentcreditorinstanceid=ci.creditorinstanceid 
		inner join tblcreditor c on ci.creditorid=c.creditorid'
	set @select = 'a.accountid as RelationID, c.name [Creditor], ci.accountnumber [Account Number],ci.referencenumber [Reference Number]'
	set @where = 'a.clientid=' + convert(varchar, @dependencyid)
end else if @join='tblContact' begin
	set @join = @join + ' c'
	set @select = 'c.contactid as RelationID, c.firstname [First Name], c.lastname [Last Name], c.EmailAddress Email'
	set @where = 'c.creditorid=' + convert(varchar, @dependencyid)
end else if @join='tblRegister' begin
	set @join = @join + ' r inner join tblentrytype et on r.entrytypeid=et.entrytypeid'
	set @select = 'r.registerid as RelationID, et.Name [Entry Type], r.transactiondate [Date] , r.amount [Amount]'
	set @where = 'r.clientid=' + convert(varchar, @dependencyid)
end else if @join='tblRegisterPayment' begin
	set @join = @join + ' rp inner join tblregister r on rp.feeregisterid=r.registerid inner join tblentrytype et on r.entrytypeid=et.entrytypeid'
	set @select = 'rp.registerpaymentid as RelationID, et.Name [Fee Type], rp.paymentdate [Date], rp.amount [Amount]'
	set @where = 'r.clientid=' + convert(varchar, @dependencyid)
--- Added for RelationTypeId=19 Matter
end else if @join='tblMatter' begin
	set @join =@join 
	set @select = 'MatterId as [RelationId], MatterNumber [MatterNumber], CONVERT(VARCHAR(10),MatterDate,  101)[MatterDate], MatterMemo[MatterMemo]' 
	set @where= 'clientId='+convert(varchar, @dependencyid)+ 'order by [MatterDate] desc'
--- Added for RelationTypeId=20 Client Request
end else if @join='tblClientRequests' begin
	set @join = @join + ' c inner join tblClientRequestStatusCode p on c.ClientRequestStatusCodeId=p.ClientRequestStatusCodeId' 
	set @select = 'ClientRequestId as [RelationId], CONVERT(VARCHAR(10),ClientRequestDateTime,  101)[RequestDate], ClientRequestDecription[Request Description], p.ClientRequestStatusCode [ClientRequestStatus]' 
	set @where= 'clientId='+convert(varchar, @dependencyid)+ 'order by [ClientRequestDateTime] desc'

end

if len(@select)>0
	exec ('select ' + @select + ' from ' + @join + ' where ' + @where)
else
	select 1 as ID, 'Add to stp_GetRelatables' as ToImplement

---***** Update function getentitydisplay ****
ALTER function [dbo].[getentitydisplay]
(
	@relationtypeid int,
	@relationid int
)

returns varchar(100)
begin

declare @result varchar(100)

if @relationtypeid = 1 begin --client
	set @result=
	(
		select 
			coalesce(firstname,'?') + ' ' + coalesce(lastname,'?')
		from
			tblclient c inner join
			tblperson p on c.primarypersonid=p.personid
		where
			c.clientid=@relationid
	)
end else if @relationtypeid = 2 begin --creditor account
	set @result=
	(
		select 
			cr.name  + ' ' + 
			isnull(
			case 
				when len(ci.accountnumber)>=5 then '***' + substring(ci.accountnumber,len(ci.accountnumber)-3,len(ci.accountnumber))
				else ci.accountnumber
			end
			,'')
		from
			tblaccount a inner join
			tblcreditorinstance ci on a.currentcreditorinstanceid=ci.creditorinstanceid inner join
			tblcreditor cr on ci.creditorid=cr.creditorid
		where
			a.accountid=@relationid
	)
end else if @relationtypeid = 3 begin --contact
	set @result=
	(
		select 
			co.firstname + ' ' + co.lastname
		from
			tblcontact co
		where
			co.contactid=@relationid
	)
end else if @relationtypeid = 4 begin --register
	set @result=
	(
		select 
			et.[name] + ' of $' + convert(varchar,abs(r.amount),1) + ' on ' + convert(varchar,transactiondate,6)
		from
			tblregister r inner join
			tblentrytype et on r.entrytypeid=et.entrytypeid
		where
			r.registerid=@relationid
	)
end else if @relationtypeid = 5 begin --register payment
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(r.amount),1) + ' on ' + convert(varchar,paymentdate,6) + ' for ' + et.[name]
		from
			tblregisterpayment rp inner join
			tblregister r on rp.feeregisterid=r.registerid inner join
			tblentrytype et on r.entrytypeid=et.entrytypeid
		where
			rp.registerpaymentid=@relationid
	)
end else if @relationtypeid = 8 begin --person/applicant
	set @result=
	(
		select 
			firstname + ' ' + lastname
		from
			tblperson p
		where
			p.personid=@relationid
	)
end else if @relationtypeid = 11 begin --ach rule
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(depositamount),1) + ' starting ' + convert(varchar,startdate,6)
		from
			tblruleach ar
		where
			ar.ruleachid=@relationid
	)
end else if @relationtypeid = 13 begin --ad hoc ach
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(depositamount),1) + ' for ' + convert(varchar,depositdate,6)
		from
			tbladhocach ah
		where
			ah.adhocachid=@relationid
	)
end else if @relationtypeid = 14 begin --check to print
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(amount),1) + ' for ' + convert(varchar,checkdate,6)
		from
			tblchecktoprint ctp
		where
			ctp.checktoprintid=@relationid
	)
end else if @relationtypeid = 15 begin --negotiation
	set @result=
	(
		select 
			'for account ' + dbo.getentitydisplay(2,m.accountid)
		from
			tblmediation m
		where
			m.mediationid=@relationid
	)


--- Added for MatterNote by usutyono 

end else if @relationtypeid = 19 begin --matter
	set @result=
	(
		select 
			MatterNumber+'--'+MatterMemo
		from
			tblMatter m
		where
			m.MatterId=@relationid
	)

-- added 1.20.2010 for displaying Client Request list
end else if @relationtypeid = 20 begin  
	set @result=
	(
		select 
			CONVERT(VARCHAR(10),ClientRequestDateTime,  101)+'--'+
			ClientRequestDecription
		from
			dbo.tblClientRequests
		where
			ClientRequestId=@relationid

	)


end


return @result

end
---********




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_GetClientRequestsbyClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[stp_GetClientRequestsbyClientId]
(
	@ClientId int,
	@OrderBy varchar(100)=''cr.Created''
)
AS


BEGIN

declare @clientjoin varchar(1000)

set @clientjoin = ''Select cr.* ,
u1.FirstName+'''' ''''+u1.LastName as CreatedByName,
u2.FirstName+'''' ''''+u2.LastName as LastModifiedName,
crs.ClientRequestStatusCode

from dbo.tblClientRequests cr
join dbo.tblClientRequestStatusCode crs on crs.ClientRequestStatusCodeId= cr.ClientRequestStatusCodeId
join dbo.tblClient c on c.ClientId=cr.ClientId
join dbo.tblCompany co on co.CompanyId=c.CompanyId
join dbo.tblUser u1 on u1.Userid = cr.CreatedBy
left outer join dbo.tblUser u2 on u2.Userid = cr.LastModifiedBy

where cr.ClientId= '' + cast(@ClientId as varchar) +'' Order by '' + @Orderby

exec(@clientjoin)

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_GetClientRequestDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





/*
      Revision    : <00 - 19 January 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Get ClientRequests Detail
*/


CREATE  procedure [dbo].[stp_GetClientRequestDetails]
(
	@ClientRequestId int
)
AS


BEGIN

Select 

CONVERT(VARCHAR(10),cr.ClientRequestDateTime,  101) [ClientRequestDateTime] ,
co.Name [Firm],
* 

from dbo.tblClientRequests cr
join dbo.tblClientRequestStatusCode crs on crs.ClientRequestStatusCodeId= cr.ClientRequestStatusCodeId
join dbo.tblClient c on c.ClientId=cr.ClientId
join dbo.tblCompany co on co.CompanyId=c.CompanyId
where cr.ClientRequestId=@ClientRequestId


END









' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_InsertClientRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
	Revision	: <02 - 20 January 2010>
	Category	: [TimeMatter]
	Type        : {New}
	Decription	: Add new Client request
*/


CREATE PROCEDURE [dbo].[stp_InsertClientRequest]
(
 
@ClientrequestId int = NULL,
@ClientId  int,
@ClientRequestStatusCodeId int,
@ClientRequestDateTime datetime,
@ClientRequestDecription varchar(MAX),
@CreatedBy int
)
AS

IF NOT EXISTS ( Select (ClientRequestId) from tblClientRequests where ClientRequestId=@ClientRequestId)

BEGIN

--- Please add transaction and roll back here!

INSERT INTO dbo.tblClientRequests
(
ClientId
,ClientRequestStatusCodeId
,ClientRequestDateTime
,ClientRequestDecription
,Created
,CreatedBy
,LastModified
,LastModifiedBy
)

VALUES
(
@ClientId  ,
@ClientRequestStatusCodeId ,
@ClientRequestDateTime ,
@ClientRequestDecription, 
getdate(),
@CreatedBy,
getdate(),
@CreatedBy 
)


SELECT NEWID = SCOPE_IDENTITY()

END

ELSE 

BEGIN

Update dbo.tblClientRequests

SET ClientRequestStatusCodeId =@ClientRequestStatusCodeId,
	LastModified = getdate(),
	LastModifiedBy =@CreatedBy


Where ClientRequestId=@ClientRequestId

END' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_GetRelationsForClientRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
      Revision    : <00 - 19 January 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Get Relations for ClientRequests
*/


CREATE  procedure [dbo].[stp_GetRelationsForClientRequest]
(
	@ClientRequestId int
)
AS


BEGIN

Select 

*,
rt.Name [RelationTypeName], 
dbo.getentitydisplay(rt.relationtypeid,relationid) [relationname]


from dbo.tblClientRequestRelation crr
join dbo.tblClientRequests c on c.ClientRequestId=crr.ClientRequestId
join dbo.tblRelationType rt on rt.RelationTypeId=crr.RelationTypeId


where crr.ClientRequestId=@ClientRequestId


END'

END

