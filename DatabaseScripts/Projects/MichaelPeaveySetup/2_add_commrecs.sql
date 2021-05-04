
set identity_insert tblcommrec on

insert tblcommrec (commrecid,commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,accounttypeid)
values (37,1,'PEAV OA','Peavey Operating Account',1,0,0,0,'ACH','**NEED**','**NEED**','**NEED**','C',getdate(),820,getdate(),820,5,3)

insert tblcommrec (commrecid,commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,accounttypeid)
values (38,1,'PEAV GCA','Peavey General Clearing Account',1,0,0,1,'ACH','','0','0','C',getdate(),820,getdate(),820,5,1)

insert tblcommrec (commrecid,commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,accounttypeid)
values (39,1,'PEAV Trust','Peavey Client Trust',1,0,1,0,'ACH','','0','0','C',getdate(),820,getdate(),820,5,2)

set identity_insert tblcommrec off