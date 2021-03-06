/****** Object:  Table [dbo].[tblNegotiationAssignment]    Script Date: 01/28/2008 13:16:26 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationAssignment')
	BEGIN
			DROP TABLE tblNegotiationAssignment
	END

CREATE TABLE [dbo].[tblNegotiationAssignment](
	[NegotiationAssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[HeaderName] [nvarchar](100) NOT NULL,
	[ColumnName] [nvarchar](50) NOT NULL,
	[SQL] [nvarchar](250) NULL,
	[SQLAggregation] [nvarchar](50) NULL,
	[Aggregation] [nvarchar](50) NOT NULL,
	[GroupedAggregation] [nvarchar](50) NULL,
	[Format] [char](1) NULL,
	[Order] [int] NULL,
	[Default] [bit] NOT NULL CONSTRAINT [DF_tblNegotiationAssignment_Default]  DEFAULT ((0)),
	[CanGroup] [bit] NOT NULL CONSTRAINT [DF_tblNegotiationAssignment_CanGroup]  DEFAULT ((0)),
	[DistributeBy] [bit] NOT NULL CONSTRAINT [DF_tblNegotiationAssignment_DistributeBy]  DEFAULT ((0))
) ON [PRIMARY]


EXEC ('
SET IDENTITY_INSERT tblNegotiationAssignment ON
INSERT INTO tblNegotiationAssignment ([NegotiationAssignmentID],[HeaderName],[ColumnName],[SQL],[SQLAggregation],[Aggregation],[GroupedAggregation],[Format],[Order],[Default],[CanGroup],[DistributeBy]) VALUES (''26'',''State'',''ApplicantState'',''ApplicantState'',''count(ApplicantState)'',''sum'',null,null,''1'',''0'',''1'',''0'')
INSERT INTO tblNegotiationAssignment ([NegotiationAssignmentID],[HeaderName],[ColumnName],[SQL],[SQLAggregation],[Aggregation],[GroupedAggregation],[Format],[Order],[Default],[CanGroup],[DistributeBy]) VALUES (''27'',''Funds Available'',''FundsAvailable'',''FundsAvailable'',''sum(FundsAvailable)'',''sum'',null,''C'',''3'',''0'',''0'',''1'')
INSERT INTO tblNegotiationAssignment ([NegotiationAssignmentID],[HeaderName],[ColumnName],[SQL],[SQLAggregation],[Aggregation],[GroupedAggregation],[Format],[Order],[Default],[CanGroup],[DistributeBy]) VALUES (''28'',''Total Debt'',''CurrentAmount'',''CurrentAmount'',''sum(CurrentAmount)'',''sum'',null,''C'',''4'',''0'',''0'',''0'')
INSERT INTO tblNegotiationAssignment ([NegotiationAssignmentID],[HeaderName],[ColumnName],[SQL],[SQLAggregation],[Aggregation],[GroupedAggregation],[Format],[Order],[Default],[CanGroup],[DistributeBy]) VALUES (''29'',''Client Count'',''ClientID'',''DISTINCT ClientID'',''count(DISTINCT ClientID)'',''sum'',null,null,''2'',''0'',''0'',''0'')
INSERT INTO tblNegotiationAssignment ([NegotiationAssignmentID],[HeaderName],[ColumnName],[SQL],[SQLAggregation],[Aggregation],[GroupedAggregation],[Format],[Order],[Default],[CanGroup],[DistributeBy]) VALUES (''30'',''Zip Code'',''ApplicantZipCode'',''substring(ApplicantZipCode, 1, 2)'',''count(ApplicantZipCode)'',''sum'',null,null,''1'',''0'',''1'',''0'')
INSERT INTO tblNegotiationAssignment ([NegotiationAssignmentID],[HeaderName],[ColumnName],[SQL],[SQLAggregation],[Aggregation],[GroupedAggregation],[Format],[Order],[Default],[CanGroup],[DistributeBy]) VALUES (''31'',''Last Name'',''ApplicantLastName'',''substring(ApplicantLastName, 1, 1)'',''count(ApplicantLastName)'',''sum'',null,null,''0'',''1'',''1'',''0'')
SET IDENTITY_INSERT tblNegotiationAssignment OFF
')