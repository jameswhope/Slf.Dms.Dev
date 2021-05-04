  
--*** add tables for ClientRequest functionalities   ****
--*** 1. add tblClientRequests ******
--*** 2. add tblClientRequestRelation     ****
--*** 3. add tblClientRequestStatusCode   ****
--*** 4. populate tblClientRequestLookup tables ***
--*** 5. add RelationTypeId 20 into tblRelationType for ClientRequest
--*** Revision 1 1/21/2010 ****

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClientRequests]') AND type in (N'U'))

BEGIN
/****** Object:  Table [dbo].[tblClientRequests]    Script Date: 01/21/2010 08:19:47 ******/
print 'table does not exists'
CREATE TABLE [dbo].[tblClientRequests](
	[ClientRequestId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[ClientRequestStatusCodeId] [int] NOT NULL,
	[ClientRequestDateTime] [datetime] NOT NULL,
	[ClientRequestDecription] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblClientRequests] PRIMARY KEY CLUSTERED 
(
	[ClientRequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClientRequestRelation]') AND type in (N'U'))

BEGIN
/****** Object:  Table [dbo].[tblClientRequestRelation]    Script Date: 01/21/2010 08:20:52 ******/

CREATE TABLE [dbo].[tblClientRequestRelation](
	[ClientRequestRelationId] [int] IDENTITY(1,1) NOT NULL,
	[ClientRequestId] [int] NULL,
	[RelationTypeId] [int] NULL,
	[RelationId] [int] NULL,
 CONSTRAINT [PK_tblClientRequestRelation] PRIMARY KEY CLUSTERED 
(
	[ClientRequestRelationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClientRequestStatusCode]') AND type in (N'U'))

BEGIN


CREATE TABLE [dbo].[tblClientRequestStatusCode](
	[ClientRequestStatusCodeId] [int] IDENTITY(1,1) NOT NULL,
	[ClientRequestStatusCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientRequestStatusCodeDescr] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tblClientRequestStatusCode] PRIMARY KEY CLUSTERED 
(
	[ClientRequestStatusCodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

/******* Populate Lookup table data *****/

IF (SELECT Count(ClientRequestStatusCodeId) from dbo.tblClientRequestStatusCode) <1

BEGIN

SET IDENTITY_INSERT dbo.tblClientRequestStatusCode ON

INSERT INTO dbo.tblClientRequestStatusCode(ClientRequestStatusCodeId,ClientRequestStatusCode,ClientRequestStatusCodeDescr) VALUES (1,'Pending', 'Request is Pending')
INSERT INTO dbo.tblClientRequestStatusCode(ClientRequestStatusCodeId,ClientRequestStatusCode,ClientRequestStatusCodeDescr) VALUES (2,'Active', 'Request is Active')
INSERT INTO dbo.tblClientRequestStatusCode(ClientRequestStatusCodeId,ClientRequestStatusCode,ClientRequestStatusCodeDescr) VALUES (3,'Resolved', 'Request is Resolved')

SET IDENTITY_INSERT dbo.tblClientRequestStatusCode OFF



END

--*** Add relationTypeId =20 ****
IF NOT EXISTS (SELECT RelationTypeID FROM dbo.tblRelationType where RelationTypeId =20)

BEGIN

SET IDENTITY_INSERT dbo.tblRelationType ON
 
INSERT INTO tblRelationType 
(
RelationTypeID
,[Table]
,KeyField
,[Name]
,IconURL
,NavigateURL
,DocRelation
)

VALUES
(
20,
'tblClientRequests',
'ClientRequestId',
'Client Request',
'~/images/16x16_user.png',
'~/clients/client/?id=$x$',
NULL
)

SET IDENTITY_INSERT dbo.tblRelationType OFF

END