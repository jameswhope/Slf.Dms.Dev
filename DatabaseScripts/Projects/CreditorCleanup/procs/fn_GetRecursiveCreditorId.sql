drop function dbo.GetRecursiveCreditorId 
go
create function dbo.GetRecursiveCreditorId (@CreditorId int)
returns int
AS
begin
	   if not @CreditorId is null and not exists(Select CreditorId from tblcreditor Where creditorid = @CreditorId)
			begin
				declare @newcreditorid int set @newcreditorid = null

				select top 1 @newcreditorId = newvalue from tblCreditorCleanupLog 
				where oldvalue = @CreditorId and tablename = 'tblCreditor' and FieldName = 'creditorId'
				order by [when] desc

				if Not @newCreditorId is null
					Select @CreditorId = dbo.GetRecursiveCreditorId(@newCreditorId)
				else
					Select @creditorid = null
			end
  return @creditorid
end
go
