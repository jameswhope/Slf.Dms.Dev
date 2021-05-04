
if object_id('tblNegotiationColumn') is null begin

	CREATE TABLE tblNegotiationColumn
	(
		[NegotiationColumnID] [int] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](50) NOT NULL,
		[Path] [nvarchar](100) NOT NULL,
		[ImagePath] [nvarchar](100) NOT NULL,
		[OverImagePath] [nvarchar](100) NOT NULL,
		[Height] [int] NOT NULL,
		[Width] [int] NOT NULL
	)

	insert tblnegotiationcolumn (name,path,imagepath,overimagepath,height,width) values ('Home','~/negotiation/Default.aspx','~/negotiation/images/hometab_off.png','~/negotiation/images/hometab_on.png',25,60)
	insert tblnegotiationcolumn (name,path,imagepath,overimagepath,height,width) values ('Clients','~/negotiation/clients/Default.aspx','~/negotiation/images/negotiationtab_off.png','~/negotiation/images/negotiationtab_on.png',25,97)
	insert tblnegotiationcolumn (name,path,imagepath,overimagepath,height,width) values ('Email','~/negotiation/email/Default.aspx','~/negotiation/images/emailtab_off.png','~/negotiation/images/emailtab_on.png',25,61)
	insert tblnegotiationcolumn (name,path,imagepath,overimagepath,height,width) values ('Assignment','~/negotiation/assignments/Default.aspx','~/negotiation/images/assignmentstab_off.png','~/negotiation/images/assignmentstab_on.png',25,97)
	insert tblnegotiationcolumn (name,path,imagepath,overimagepath,height,width) values ('Calendar','~/negotiation/calendar/Default.aspx','~/negotiation/images/calendartab_off.png','~/negotiation/images/calendartab_on.png',25,76)

end