create table tblInitialDepositEmail
(
	ClientId int not null unique,
	ToEmailAddress varchar(100) not null,
	TypeOfDeposit varchar (50) not null,
	InitialDepositDate datetime not null,
	InitialDepositEmail datetime null,
	NonDepositEmail datetime null,
	Checked bit not null,
	primary key (ClientId)
)
insert tblInitialDepositEmail values(104853,'dhpush1000@gmail.com','ACH','2012-09-15 00:00:00.000','','',1)
insert tblInitialDepositEmail values(104857,'allin.moore@yahoo.com','Check','2012-08-28 00:00:00.000','','',1)
insert tblInitialDepositEmail values(104858,'themonk46@gmail.com','ACH','2012-09-08 00:00:00.000','','',1)
insert tblInitialDepositEmail values(104895,'pricekristy1142000@yahoo.com','ACH','2012-11-05 00:00:00.000','','',1)
insert tblInitialDepositEmail values(104896,'kara.maine@gmail.com','ACH','2012-11-17 00:00:00.000','','',1)
insert tblInitialDepositEmail values(104898,'Lianahaole@yahoo.com','ACH','2012-11-15 00:00:00.000','','',1)
