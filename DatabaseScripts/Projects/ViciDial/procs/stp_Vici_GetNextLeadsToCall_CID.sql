IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetNextLeadsToCall_CID')
	BEGIN
		DROP  Procedure  stp_Vici_GetNextLeadsToCall_CID
	END

GO

CREATE Procedure stp_Vici_GetNextLeadsToCall_CID
(
	@TopN int = 10000
)
AS
BEGIN

declare @callstartdate datetime, 
		@listid int, 
		@maxdialercount int

select @callstartdate = '2013-02-26', 
	   @maxdialercount = 8
	   
select @listid = vicimainlistid from tblvicicampaigngroup Where vicicampaignid = 'CID'

exec ('
SELECT top ' + @TopN +
' [callorder] = case 
				when l.statusid = 16 then 1 
				else 101 + DATEDIFF(d,l.created, GETDATE()) 
			  end,
l.leadapplicantid as leadid, 
l.leadphone as phone, 
l.firstname, 
l.middlename, 
l.lastname, 
l.address1 as [address], 
l.city,  
sh.statecode, 
l.zipcode, 
l.dob, 
l.cellphone as altphone, 
l.email, 
l.dialerstatusid, 
NULL as outcallerid, 
l.created as [created], 
+ ''' + @listid + ''' as vicimainlistid,
NULL as [clientid]
FROM tblleadapplicant l with (nolock)
join vw_states_hours sh with (nolock) on l.stateid = sh.stateid and (getdate() between sh.startdate and sh.enddate)
join tbldialerstatus d with (nolock) on d.dialerstatusid = l.dialerstatusid and d.usedialer = 1
join tblLeadProducts p on p.ProductID = l.ProductID
join tblLeadVendors v on v.VendorID = p.VendorID and v.Internal = 1
where
	(l.statusid in (13, 15, 16, 17))
 	and (l.created > ''' + @callstartdate + ''' or isnull(l.dialerlastrecycled, ''1900-01-01'') > '''+ @callstartdate + ''')
	and (l.dialerretryafter is null or l.dialerretryafter < getdate())
	and (l.dialercount < ' + @maxdialercount + ')
	and (l.leadphone <> ''(   )    -    '' and isnull(l.leadphone, '''') <> '''')
order by 1, l.created desc

')

END

GO

 

