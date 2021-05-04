IF not exists(SELECT EntryTypeId from tblEntryType where Name = 'Payment Arrangement Fee')BEGIN
	INSERT INTO [tblEntryType]([Type],[Name],[DisplayName],[Order],[Fee],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[System],[IsMatterEntry],[IsFlateRate],[Rate])
	SELECT [Type],'Payment Arrangement Fee'[Name],'Payment Arrangement Fee'[DisplayName],[Order],[Fee]
	,getdate()[Created],750[CreatedBy],getdate()[LastModified],750[LastModifiedBy],[System],[IsMatterEntry],1[IsFlateRate],[Rate]
	from [tblEntryType]
	where EntryTypeId = 1
END
 