IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_lexxsign_getFirmName')
	BEGIN
		DROP  Procedure  stp_lexxsign_getFirmName
	END

GO

create procedure stp_lexxsign_getFirmName
(
	@signingBatchID varchar(200)
)
as
BEGIN
/* dev
	declare @@signingBatchID varchar(200)
	set @@signingBatchID = '461140e4-ba6a-4c2c-8bbf-edee7fb8dedc'
*/
	--leaddocument
	select co.name from tblleaddocuments ld inner join tblleadapplicant la on la.leadapplicantid = ld.leadapplicantid inner join tblcompany co on co.companyid = la.companyid 
	where ld.signingbatchid = @signingBatchID
	union all
	--lexxsigndocs
	select co.name 
	from tbllexxsigndocs lsd 
	inner join tblclient c on c.clientid = lsd.clientid 
	inner join tblcompany co on co.companyid = c.companyid 
	where lsd.signingbatchid = @signingBatchID
END	


GRANT EXEC ON stp_lexxsign_getFirmName TO PUBLIC




