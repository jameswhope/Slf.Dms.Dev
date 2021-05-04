 IF col_length('tblLeadBanks', 'ACH') is null
	Alter table tblLeadBanks Add ACH bit not null default 1 
GO	
Update tblLeadBanks Set
ACH = 0
Where Created > Cast('2009-09-30 18:32:00' as datetime)
and (ltrim(rtrim(isnull(RoutingNumber, '')))='' or Ltrim(rtrim(isnull(AccountNumber, '')))='')