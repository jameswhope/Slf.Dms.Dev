ALTER procedure [dbo].[stp_SaveCreditLiabilityLookup]
(
	@CreditorName varchar(50),
	@Street varchar(75),
	@City varchar(30),
	@StateCode varchar(10),
	@PostalCode varchar(15),
	@Contact varchar(20),
	@UserId int = 17
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
		-- and has a Creditor Id
		and CreditorID is not null

	if isnull(@CreditLiabilityLookupID,-1) = -1 begin
	
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
		
		if 	isnull(@CreditorGroupID, -1) = -1
		begin
			insert into tblCreditorGroup ([Name], Created, CreatedBy, LastModified, LastModifiedBy)
			Values (@CreditorName, GetDate(), @UserId, GetDate(), @UserId)
			
			set @CreditorGroupID = scope_identity()
		end

		select @CreditorID=creditorid
		from tblcreditor
		where street = @Street
			and city = @City
			and stateid = @StateID
			and zipcode = @PostalCode
			and creditorgroupid = @CreditorGroupID
			
		if 	isnull(@CreditorID, -1) = -1
		begin
			-- Set default StateId to CA if not present
			if @StateId is null select @StateId = 5
		
			insert into tblCreditor ([Name],Street,Street2,City,StateId,ZipCode,Created,CreatedBy,LastModified,LastModifiedBy,CreditorGroupId,CreditorAddressTypeId)
			values (@CreditorName, @Street, '', @City, @StateId, @PostalCode, GetDate(), @UserId, GetDate(), @UserId, @CreditorGroupID,105)
			
			set @CreditorID = scope_identity()
		end
		
		if isnull(@CreditorID, -1) > 0 begin
			update tblCreditLiabilityLookup 
			set creditorid = @CreditorID
			where creditliabilitylookupid = @CreditLiabilityLookupID
		end
	end

	select @CreditLiabilityLookupID

end
