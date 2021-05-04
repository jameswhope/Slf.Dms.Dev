
set identity_insert tbltasktype on

insert tbltasktype (tasktypeid,tasktypecategoryid,name,defaultdescription,created,createdby,lastmodified,lastmodifiedby)
values (12,1,'Resolve Data Entry','All of the creditors in this worksheet have been validated. You can now resolve this worksheet.',getdate(),820,getdate(),820)

insert tbltasktype (tasktypeid,tasktypecategoryid,name,defaultdescription,created,createdby,lastmodified,lastmodifiedby)
values (13,4,'Resolve Verification','All of the creditors in this worksheet have been validated. You can now resolve this worksheet.',getdate(),820,getdate(),820)

set identity_insert tbltasktype off