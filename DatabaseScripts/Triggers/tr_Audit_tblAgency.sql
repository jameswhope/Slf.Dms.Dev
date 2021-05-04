IF OBJECT_ID ('dbo.tr_Audit_tblAgency', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_Audit_tblAgency
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.tr_Audit_tblAgency
   ON dbo.tblAgency
   AFTER INSERT,UPDATE,DELETE
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblAgency ON

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		insert dms_warehouse.dbo.AUDIT_tblAgency 
		(
		   [AgencyID]
		  ,[Code]
		  ,[Name]
		  ,[ImportAbbr]
		  ,[Commercial]
		  ,[EIN]
		  ,[UserId]
		  ,[PrimaryAgentID]
		  ,[RetainerFeePercent]
		  ,[SettlementFeePercent]
		  ,[MaintenanceFee]
		  ,[MaintenanceFeeDay]
		  ,[AdditionalAccountFee]
		  ,[ReturnedCheckFee]
		  ,[OvernightFee]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[CheckingSavings]
		  ,[Contact1]
		  ,[Contact2]
		  ,[IsCommRec]
		  ,[DbName]
		  ,[RowAddedBy]
		  ,[Deleted]
		)
		select
		   [AgencyID]
		  ,[Code]
		  ,[Name]
		  ,[ImportAbbr]
		  ,[Commercial]
		  ,[EIN]
		  ,[UserId]
		  ,[PrimaryAgentID]
		  ,[RetainerFeePercent]
		  ,[SettlementFeePercent]
		  ,[MaintenanceFee]
		  ,[MaintenanceFeeDay]
		  ,[AdditionalAccountFee]
		  ,[ReturnedCheckFee]
		  ,[OvernightFee]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[CheckingSavings]
		  ,[Contact1]
		  ,[Contact2]
		  ,[IsCommRec]
		  ,db_name()
		  ,SUSER_SNAME()
		  ,1
		from 
			deleted
	end
	else begin
		insert dms_warehouse.dbo.AUDIT_tblAgency 
		(
		   [AgencyID]
		  ,[Code]
		  ,[Name]
		  ,[ImportAbbr]
		  ,[Commercial]
		  ,[EIN]
		  ,[UserId]
		  ,[PrimaryAgentID]
		  ,[RetainerFeePercent]
		  ,[SettlementFeePercent]
		  ,[MaintenanceFee]
		  ,[MaintenanceFeeDay]
		  ,[AdditionalAccountFee]
		  ,[ReturnedCheckFee]
		  ,[OvernightFee]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[CheckingSavings]
		  ,[Contact1]
		  ,[Contact2]
		  ,[IsCommRec]
		  ,[DbName]
		  ,[RowAddedBy]
		)
		select
		   [AgencyID]
		  ,[Code]
		  ,[Name]
		  ,[ImportAbbr]
		  ,[Commercial]
		  ,[EIN]
		  ,[UserId]
		  ,[PrimaryAgentID]
		  ,[RetainerFeePercent]
		  ,[SettlementFeePercent]
		  ,[MaintenanceFee]
		  ,[MaintenanceFeeDay]
		  ,[AdditionalAccountFee]
		  ,[ReturnedCheckFee]
		  ,[OvernightFee]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[CheckingSavings]
		  ,[Contact1]
		  ,[Contact2]
		  ,[IsCommRec]
		  ,db_name()
		  ,SUSER_SNAME()
		from 
			inserted
	end
	
	SET NOCOUNT OFF
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblAgency OFF
END
GO