IF OBJECT_ID ('dbo.tr_Audit_tblAttyRelation', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_Audit_tblAttyRelation
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
CREATE TRIGGER dbo.tr_Audit_tblAttyRelation
   ON dbo.tblAttyRelation
   AFTER INSERT,UPDATE,DELETE
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblAttyRelation ON

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		insert dms_warehouse.dbo.AUDIT_tblAttyRelation 
		(
		   [AttyPivotID]
		  ,[AttorneyID1]
		  ,[AttorneyID2]
		  ,[CompanyID]
		  ,[AttyRelation]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[EmployedState]
		  ,[DbName]
		  ,[RowAddedBy]
		  ,[Deleted]
		)
		select
		   [AttyPivotID]
		  ,[AttorneyID1]
		  ,[AttorneyID2]
		  ,[CompanyID]
		  ,[AttyRelation]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[EmployedState]
		  ,db_name()
		  ,SUSER_SNAME()
		  ,1
		from 
			deleted
	end
	else begin
		insert dms_warehouse.dbo.AUDIT_tblAttyRelation 
		(
		   [AttyPivotID]
		  ,[AttorneyID1]
		  ,[AttorneyID2]
		  ,[CompanyID]
		  ,[AttyRelation]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[EmployedState]
		  ,[DbName]
		  ,[RowAddedBy]
		)
		select
		   [AttyPivotID]
		  ,[AttorneyID1]
		  ,[AttorneyID2]
		  ,[CompanyID]
		  ,[AttyRelation]
		  ,[Created]
		  ,[CreatedBy]
		  ,[LastModified]
		  ,[LastModifiedBy]
		  ,[EmployedState]
		  ,db_name()
		  ,SUSER_SNAME()
		from 
			inserted
	end
	
	SET NOCOUNT OFF
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblAttyRelation OFF
END
GO