IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_AutoInsertLeadApplicant')
	BEGIN
		DROP  Procedure  stp_Vici_AutoInsertLeadApplicant
	END

GO

CREATE Procedure stp_Vici_AutoInsertLeadApplicant
@PhoneNumber varchar(10),
@DID varchar(10),
@UserID int
AS
BEGIN

Declare @FormattedPhone varchar(14)  

select @PhoneNumber = right(@Phonenumber,10)

select @FormattedPhone = '(' + Stuff(Stuff(@PhoneNumber,7,0,'-'),4,0,') '), @DID = right(@DID,10)
 
insert into tblleadapplicant(
FirstName, 
LastName, 
LeadPhone, 
StateId, 
LeadSourceId, 
CompanyId, 
StatusId, 
ProductID, 
Cost, 
created, 
createdbyid, 
repid,
dialerretryafter)
select  
'' as firstname, 
'' as lastname, 
@FormattedPhone as leadphone, 
isnull(w.stateid,0) as stateid, 
p.defaultsourceid , 
isnull(s.companyid,0) as companyid, 
16 as statusid,
p.productid, 
p.cost,
GetDate() as created,
@UserId as createdbyid,
@UserId as repid,
DateAdd(hh,1,GetDate()) as dialerretryafter
from tblleadproductdid pd 
inner join tblleadproducts p on pd.productid = p.productid
left join vw_areacode_state w on w.areacode = left(@PhoneNumber,3)
left join tblstate s on w.stateid = s.stateid
where pd.did = @DID
and s.companyid > 0

select scope_identity()

END


