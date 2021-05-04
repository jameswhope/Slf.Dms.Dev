 
update tblNegotiationColumn set name='Assignments' where negotiationcolumnid = 4
update tblNegotiationColumn set name='Attach SIF' where negotiationcolumnid = 9

insert tblNegotiationColumn (name,path,imagepath,overimagepath,height,width,seq,usergroupid)
values ('My Stats','~/negotiation/mystats.aspx','','',25,97,5,4)