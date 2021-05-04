delete from tblNegotiationColumn  where [name] = 'Manager Approval' and UserGroupID in (4,11)

insert tblNegotiationColumn (Name,Path,ImagePath,OverImagePath,Height,Width,Seq,UserGroupID)
values ('Manager Approval','~/negotiation/managers/default.aspx','~/negotiation/images/managerstab_off.png','~/negotiation/images/managerstab_on.png',25,60,5,4) 
insert tblNegotiationColumn (Name,Path,ImagePath,OverImagePath,Height,Width,Seq,UserGroupID)
values ('Manager Approval','~/negotiation/managers/default.aspx','~/negotiation/images/managerstab_off.png','~/negotiation/images/managerstab_on.png',25,60,5,11) 