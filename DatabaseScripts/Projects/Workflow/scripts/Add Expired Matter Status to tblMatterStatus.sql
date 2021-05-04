declare @Exists int
set @Exists  = null
select @Exists  = matterstatusid from tblmatterstatus  where MatterStatus = 'EXPIRED'

if @Exists is null
	BEGIN
		insert into tblmatterstatus (MatterStatus,MatterStatusDescr,Created,CreatedBy,lastModified,lastModifiedBy,IsMatterActive)
		values ('EXPIRED','EXPIRED Matter',getdate(),750,getdate(),750,0)
	END