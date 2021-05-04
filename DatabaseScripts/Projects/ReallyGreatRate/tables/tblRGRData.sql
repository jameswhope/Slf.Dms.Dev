
CREATE TABLE [tblRGRData]
(
	[RGRDataID] [int] IDENTITY(1,1) NOT NULL,
	[Status] varchar(20),
	[XmlString] [varchar](max) NULL,
	[VendorCode] varchar(20),
	[ProductID] int,
	[AffiliateID] int,
	[Created] [datetime] NOT NULL DEFAULT (getdate()),
	[Lead_Id] varchar(30),
	[Home_Phone] varchar(10) null
) 