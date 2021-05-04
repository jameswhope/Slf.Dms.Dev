if exists (select * from sysobjects where name = 'stp_SaveCreditLiabilityLookup')
	drop procedure stp_SaveCreditLiabilityLookup
go 

create procedure [dbo].[stp_SaveCreditLiabilityLookup]
(
	@CreditorName varchar(50),
	@Street varchar(75),
	@City varchar(30),
	@StateCode varchar(10),
	@PostalCode varchar(15),
	@Contact varchar(20)
)
as
begin
	-- at this point we've just saving creditors from the credit report, don't know which ones the user will
	-- choose to import yet, if any

	-- returns CreditLiabilityLookupID

	declare @CreditLiabilityLookupID int, @CreditorGroupID int, @CreditorID int, @StateID int
	
	set @CreditLiabilityLookupID = -1
	set @CreditorGroupID = -1 
	set @CreditorID = -1 	


	-- does the lookup already exist?
	select @CreditLiabilityLookupID=CreditLiabilityLookupID
	from tblCreditLiabilityLookup
	where CreditorName=@CreditorName
		and Street=@Street
		and City=@City
		and StateCode=@StateCode
		and PostalCode=@PostalCode

	if @CreditLiabilityLookupID = -1 begin
	
		insert tblCreditLiabilityLookup (CreditorName,Street,City,StateCode,PostalCode,Contact)
		values (@CreditorName,@Street,@City,@StateCode,@PostalCode,@Contact)
		
		set @CreditLiabilityLookupID = scope_identity()
		
		-- maybe there's an exact match in the system already and we can assign it to the lookup
		select @StateID=StateID 
		from tblState 
		where abbreviation = @StateCode
	
		select @CreditorGroupID=creditorgroupid
		from tblcreditorgroup
		where name = @CreditorName

		select @CreditorID=creditorid
		from tblcreditor
		where street = @Street
			and city = @City
			and stateid = @StateID
			and zipcode = @PostalCode
			and creditorgroupid = @CreditorGroupID
		
		if @CreditorID > 0 begin
			update tblCreditLiabilityLookup 
			set creditorid = @CreditorID
			where creditliabilitylookupid = @CreditLiabilityLookupID
		end
	end

	select @CreditLiabilityLookupID

end