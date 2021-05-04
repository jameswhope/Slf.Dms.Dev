IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ConvertToMaintFeeCap')
	BEGIN
		DROP  Procedure  stp_ConvertToMaintFeeCap
	END

GO

CREATE Procedure stp_ConvertToMaintFeeCap
@ClientId int,
@UserId int
AS
Begin

	declare @oldmaintfeecap money 
	declare @newmaintfeecap money 
	declare @oldmonthlyfee money
	declare @newmonthlyfee money
	declare @oldsubsequentmonthlyfee money
	declare @newsubsequentmonthlyfee money
	declare @oldsubmaintfeestart datetime
	declare @newsubmaintfeestart datetime
	declare @oldadditionalaccfee money
	declare @newadditionalaccfee money
	
	
	select @oldmaintfeecap = null
	
	--only for SD clients
	If exists(Select l.LeadApplicantId From tblLeadApplicant l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = @ClientId)
	begin
		--only for not maint fee cap clients
		--get the old values
		select 
			@oldmaintfeecap = maintenancefeecap,
			@oldmonthlyfee = monthlyfee,
			@oldsubsequentmonthlyfee = subsequentmaintfee,
			@oldsubmaintfeestart = submaintfeestart,
			@oldadditionalaccfee = AdditionalAccountFee
		from tblclient
		where clientid = @clientid
		
		if @oldmaintfeecap is null or not @oldmaintfeecap > 0
		begin
			--convert to struct
			
			--get the new values
			select @newmaintfeecap = Cast(Value as Money) From tblproperty where [name] = 'EnrollmentMaintenanceFeeCap'	
			select @newmonthlyfee = Cast(Value as Money) From tblproperty where [name] = 'EnrollmentMaintenanceFee'
			select @newsubsequentmonthlyfee = null
			select @newsubmaintfeestart = null
			select @newadditionalaccfee = 0.00
					
			--convert client
			update tblclient set
			maintenancefeecap = @newmaintfeecap,
			monthlyfee = @newmonthlyfee,
			subsequentmaintfee = @newsubsequentmonthlyfee,
			submaintfeestart = @newsubmaintfeestart,
			additionalaccountfee = @newadditionalaccfee,
			LastModified = GetDate(),
			LastModifiedBy = @UserId
			where clientid = @clientid
			
			--update leadtables
			Update tblLeadCalculator Set
			maintenancefeecap = @newmaintfeecap,
			servicefeeperacct = @newmonthlyfee
			where leadapplicantid = (Select l.LeadApplicantId From tblLeadApplicant l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = @ClientId)
						
			--log changes
			insert into tblConvertFeeStructLookup	(ClientId, Converted, ConvertedBy, 
													FromStruct, ToStruct, 
													oldmonthlyfee, newmonthlyfee,
													oldsubsequentmonthlyfee, newsubsequentmonthlyfee,
													oldsubmaintfeestart, newsubmaintfeestart,
													oldadditionalaccfee, newadditionalaccfee,
													oldmaintfeecap, newmaintfeecap)
											values	(@ClientId, GetDate(), @UserId, 
													 1, 2,
													 @oldmonthlyfee, @newmonthlyfee,
													 @oldsubsequentmonthlyfee, @newsubsequentmonthlyfee,
													 @oldsubmaintfeestart, @newsubmaintfeestart,
													 @oldadditionalaccfee, @newadditionalaccfee,
													 @oldmaintfeecap, @newmaintfeecap)	
													 
			--addnote
			Insert Into tblNote(Subject, Value, Created, CreatedBy, LastModified, LastModifiedBy, OldTable, OldId, ClientID )
			Values ('SD Client Fee Structure Conversion', 'Client converted to a new fee structure. Service fee per account with a maximum fee amount.', GetDate(), @UserId, GetDate(), @UserId, Null, Null, @ClientID)
										 
													
		end 
		else
			RAISERROR ('This client does not qualify for conversion',11, 1)
	end
	else
		RAISERROR ('This client does not qualify for conversion',11, 1)
End
GO


