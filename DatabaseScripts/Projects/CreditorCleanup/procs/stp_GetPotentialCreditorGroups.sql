IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPotentialCreditorGroups')
	BEGIN
		DROP  Procedure   stp_GetPotentialCreditorGroups
	END
GO

create procedure stp_GetPotentialCreditorGroups
(
	@creditor varchar(100)
) 
as
begin

select 
	creditorgroupid, name 
from 
	tblcreditorgroup 
where (
	difference(ltrim(rtrim(name)), @creditor) > 3 
or 
	difference(@creditor, ltrim(rtrim(name))) > 3) 
order 
	by name

end
go