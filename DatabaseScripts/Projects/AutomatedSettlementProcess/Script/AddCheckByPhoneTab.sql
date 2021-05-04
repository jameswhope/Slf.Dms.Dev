delete from tblNegotiationColumn  where [name] = 'Checks By Phone' and UserGroupID in (4,11)

insert tblNegotiationColumn (Name,Path,ImagePath,OverImagePath,Height,Width,Seq,UserGroupID)
values ('Checks By Phone','~/negotiation/chkbyphone/default.aspx','~/negotiation/images/managerstab_off.png','~/negotiation/images/managerstab_on.png',25,60,5,4) 
insert tblNegotiationColumn (Name,Path,ImagePath,OverImagePath,Height,Width,Seq,UserGroupID)
values ('Checks By Phone','~/negotiation/chkbyphone/default.aspx','~/negotiation/images/managerstab_off.png','~/negotiation/images/managerstab_on.png',25,60,5,11) 



