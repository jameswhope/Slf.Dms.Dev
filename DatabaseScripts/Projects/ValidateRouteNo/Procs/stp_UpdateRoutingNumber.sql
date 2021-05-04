
create procedure stp_UpdateRoutingNumber
(
	@RoutingNumber char(9)
,	@NewRoutingNumber char(9)
,	@BankName varchar(50)
,	@Address varchar(50)
,	@City varchar(50)
,	@State varchar(50)
,	@Zipcode varchar(10)
,	@PhoneNo char(10)
)
as
begin

-- does the current (new) routing number exist?
if exists (select 1 from tblroutingnumber where routingnumber = @NewRoutingNumber) begin
	update tblroutingnumber
	set CustomerName = @BankName, [Address] = @Address, City = @City, Zipcode = left(@Zipcode,5), ZipcodeExtension = substring(@Zipcode,6,4), AreaCode = left(@PhoneNo,3), PhonePrefix = substring(@PhoneNo,4,3), PhoneSuffix = substring(@PhoneNo,7,4), ModifiedDate = getdate()
	where RoutingNumber = @NewRoutingNumber
end
else begin
	update tblroutingnumber
	set NewRoutingNumber = @NewRoutingNumber, ModifiedDate = getdate()
	where RoutingNumber = @RoutingNumber	

	insert tblroutingnumber (routingnumber,customername,[address],city,statecode,zipcode,zipcodeextension,areacode,phoneprefix,phonesuffix,insertdate,active)
	values (@NewRoutingNumber,@BankName,@Address,@City,@State,left(@Zipcode,5),substring(@Zipcode,6,4),left(@PhoneNo,3),substring(@PhoneNo,4,3),substring(@PhoneNo,7,4),getdate(),1)
end

end