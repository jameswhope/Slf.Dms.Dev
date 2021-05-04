IF OBJECT_ID ('dbo.tr_Audit_tblCommScen', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_Audit_tblCommScen
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
CREATE TRIGGER dbo.tr_Audit_tblCommScen 
   ON dbo.tblCommScen
   AFTER INSERT,UPDATE,DELETE
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblCommScen ON

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		insert dms_warehouse.dbo.AUDIT_tblCommScen (CommScenID,AgencyID,StartDate,EndDate,[Default],Created,CreatedBy,LastModified,LastModifiedBy,Seq,DbName,RowAddedBy,Deleted)
		select CommScenID,AgencyID,StartDate,EndDate,[Default],Created,CreatedBy,LastModified,LastModifiedBy,Seq,db_name(),SUSER_SNAME(),1
		from deleted
	end
	else begin
		insert dms_warehouse.dbo.AUDIT_tblCommScen (CommScenID,AgencyID,StartDate,EndDate,[Default],Created,CreatedBy,LastModified,LastModifiedBy,Seq,DbName,RowAddedBy)
		select CommScenID,AgencyID,StartDate,EndDate,[Default],Created,CreatedBy,LastModified,LastModifiedBy,Seq,db_name(),SUSER_SNAME()
		from inserted
	end
	
	SET NOCOUNT OFF
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblCommScen OFF
END
GO
