
set identity_insert tblcompany on
insert tblcompany (CompanyID,name,default,shortconame,created,createdby,lastmodified,lastmodifiedby,contact1,sigpath,controlledaccountname)
values (5,'The Law Offices of Michael P. Peavey',0,'PEAVEY',getdate(),820,getdate(),820,'Michael P. Peavey','\\nas02\Sig\signature_Peavey.jpg','Peavey General Clearing Account')
set identity_insert tblcompany off 

