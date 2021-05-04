 
if not exists (select 1 from tblcommrec where abbreviation in ('TILF OA','TMLF OA')) begin
	insert tblcommrec (commrectypeid,abbreviation,display,iscommercial,islocked,istrust,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,AccountTypeID)
	values (1,'TILF OA','The Iniguez Law Firm Operating Account',1,0,0,'ACH','Washington Mutual','322271627','4923368420','C',getdate(),820,getdate(),820,3,3)

	insert tblcommrec (commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,AccountTypeID)
	values (1,'TILF GCA','The Iniguez Law Firm General Clearing Account',1,0,0,1,'ACH','','0','0','C',getdate(),820,getdate(),820,3,1)

	insert tblcommrec (commrectypeid,abbreviation,display,iscommercial,islocked,istrust,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,AccountTypeID)
	values (1,'TILF Trust','The Iniguez Law Firm Client Trust',1,0,1,'ACH','','0','0','C',getdate(),820,getdate(),820,3,2)


	insert tblcommrec (commrectypeid,abbreviation,display,iscommercial,islocked,istrust,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,AccountTypeID)
	values (1,'TMLF OA','The Mossler Law Firm Operating Account',1,0,0,'ACH','National Bank of Indianapolis','074006674','1353994','C',getdate(),820,getdate(),820,4,3)

	insert tblcommrec (commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,AccountTypeID)
	values (1,'TMLF GCA','The Mossler Law Firm General Clearing Account',1,0,0,1,'ACH','','0','0','C',getdate(),820,getdate(),820,4,1)

	insert tblcommrec (commrectypeid,abbreviation,display,iscommercial,islocked,istrust,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,AccountTypeID)
	values (1,'TMLF Trust','The Mossler Law Firm Client Trust',1,0,1,'ACH','','0','0','C',getdate(),820,getdate(),820,4,2)
end

if not exists (select 1 from tblcommrec where abbreviation = 'LPSI') begin
	insert tblcommrec (commrectypeid,abbreviation,display,iscommercial,islocked,istrust,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby)
	values (2,'LPSI','Lexxiom Payment Systems, Inc.',1,0,0,'ACH','Inland Community Bank','122241831','003108845','C',getdate(),820,getdate(),820)
end
