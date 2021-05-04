
if object_id('tblNachaRegister2') is null begin
	create table tblNachaRegister2
	(
		NachaRegisterId int identity(1,1) not null
	,	NachaFileId int default(-1) not null
	,	[Name] varchar(50) 
	,	AccountNumber varchar(50) 
	,	RoutingNumber varchar(50) 
	,	[Type] char(1) 
	,	Amount money not null
	,	IsPersonal bit
	,	CommRecId int
	,	CompanyID int not null
	,	ShadowStoreId varchar(20)
	,	ClientID int
	,	TrustId int
	,	RegisterID int
	,	RegisterPaymentID int
	,	Created datetime default(getdate()) not null
	,	[Status] int
	,   [State] int
	,	ReceivedDate DateTime
	,	ProcessedDate DateTime	
	,	ExceptionCode varchar(255)
	,	Notes varchar(max)
	,	ExceptionResolved bit
	,	Flow varchar(6) not null
	)
end

