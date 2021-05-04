declare @cnt int
select @cnt = count(*) from tblClassifications where classification = 'Debt Defense'
if (@cnt=0)
	BEGIN
		INSERT INTO [tblClassifications]([Classification],[ClassificationDesc],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate],[Display])
		VALUES ('Debt Defense','Debt Defense',750,getdate(),750,getdate(),1)
	END