IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CleanupCreditorGroup')
	BEGIN
		DROP  Procedure   stp_CleanupCreditorGroup
	END
GO

create procedure stp_CleanupCreditorGroup
(
	@CreditorGroupID int
)
as 
begin

-- If no creditors are using this group, delete it
if (select count(*) from tblcreditor where creditorgroupid = @CreditorGroupID) = 0 and
	(select count(*) from tblleadcreditorinstance where creditorgroupid = @CreditorGroupID) = 0
begin
	delete 
	from tblcreditorgroup
	where creditorgroupid = @CreditorGroupID
end 

end
go