IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Matters_DocumentsReport')
	BEGIN
		DROP  Procedure  stp_Matters_DocumentsReport
	END

GO

CREATE Procedure stp_Matters_DocumentsReport

	(
		@criteria varchar(2000) = ''
	)
AS
BEGIN
	exec('
		select 
			[Matter] = m.matterid
			,[Document Type] = dt.displayname
			,[Client Account Number]=c.accountnumber
			,[Creditor Last 4] = ci.accountnumber
			,[Creditor Name]= cc.name
			,[State] = s.abbreviation
			,[Firm] = co.name
			,[Created By] = ru.firstname + '' '' + ru.lastname
			,[PDFPath] = ''\\'' + c.storageserver + ''\'' + c.storageroot + ''\'' + c.accountnumber + ''\'' +
			case when dr.subfolder is null then ''CreditorDocs\'' else ''CreditorDocs\'' + dr.subfolder end
			+ c.accountnumber + ''_'' + dr.doctypeid + ''_'' + dr.docid + ''_'' + dr.datestring + ''.pdf''
			,[CreateDate] = dr.relateddate
		from tblmatter m with(nolock)
			inner join tblclient c with(nolock) on c.clientid = m.clientid
			inner join tblperson p with(nolock) on p.personid = c.primarypersonid
			inner join tblstate s with(nolock) on s.stateid = p.stateid
			inner join tblcompany co with(nolock) on co.companyid = c.companyid
			left join tbldocrelation dr with(nolock) on dr.relationid = m.matterid and dr.relationtype = ''matter''
			inner join tbldocumenttype dt with(nolock) on dt.typeid = dr.doctypeid and typeId LIKE ''%M%''
			inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = m.creditorinstanceid
			inner join tblcreditor cc with(nolock) on cc.creditorid = ci.creditorid
			inner join tbluser ru with(nolock) on ru.userid = dr.relatedby 
		where isnull(m.isdeleted,0) = 0 ' 
		+ @criteria 
		+ ' Order By dr.relateddate desc
		option (fast 100)
		')
END

GO

GRANT EXEC ON stp_Matters_DocumentsReport TO PUBLIC

GO


