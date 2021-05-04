IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Verification_GetLeadLexxPVVersion')
	BEGIN
		DROP  Procedure  stp_Verification_GetLeadLexxPVVersion
	END

GO

CREATE Procedure stp_Verification_GetLeadLexxPVVersion
@leadid as int
AS
select versionid = case when companyid = 10 then 4 else 3 end from tblleadapplicant where leadapplicantid = @leadid

/*select versionid = case when p.productid is not null and p.productid in (119,142,143,144) then 2 else 1 end 
from vw_leadapplicant_client v
inner join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
left join tblleadproducts p on p.productid = l.productid
where v.clientid =  @clientId*/
/*select versionid = case when p.servicefee is null then 1 else 2 end 
from vw_leadapplicant_client v
inner join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
left join tblleadproducts p on p.productid = l.productid
where v.clientid =  @clientId*/

GO
