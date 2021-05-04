IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_esign_getDocuments')
	BEGIN
		DROP  Procedure  stp_esign_getDocuments
	END

GO

CREATE Procedure stp_esign_getDocuments
(
@batchid varchar(50)
)
as
BEGIN
	select 
	[DocumentOrder]=case d.documenttypeid
	when 774 then 1
	when 222 then 2
	when 225 then 3
	when 773 then 4
	when 223 then 5
	when 1021 then 6
	when 971 then 7
	when 121 then 8
	else 999 end
	,t.displayname, d.leaddocumentid, d.documentid,d.leadapplicantid, d.completed, d.signatoryemail, l.leadname, d.signingBatchid ,d.currentstatus
	from tblleaddocuments d join tbldocumenttype t on t.documenttypeid = d.documenttypeid join tblleadapplicant l on l.leadapplicantid = d.leadapplicantid 
	where d.signingBatchID = @batchid
	union all
	select 
	[DocumentOrder]=case d.documenttypeid
	when 'D7002' then 1
	when 'SD0001' then 2
	when 'SD0003' then 3
	when 'D7001' then 4
	when 'SD0002' then 5
	when 'SD0004' then 6
	when 'D2010' then 7
	when '9041' then 8
	else 999 end
	,t.displayname, d.lexxsigndocumentid, d.documentid,d.clientid, d.completed, d.signatoryemail, p.firstname + ' ' + p.lastname[ClientName], d.signingBatchid ,d.currentstatus
	from tblLexxSignDocs d 
	join tbldocumenttype t on t.typeid = d.documenttypeid  
	join tblClient c on c.clientid= d.clientid
	join tblperson p on p.personid = c.primarypersonid
	where d.signingBatchID = @batchid
	order by [DocumentOrder]

END

GRANT EXEC ON stp_esign_getDocuments TO PUBLIC

GO


