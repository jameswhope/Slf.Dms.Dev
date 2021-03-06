/****** Object:  StoredProcedure [dbo].[stp_LoadClientSearch]    Script Date: 11/19/2007 15:27:23 ******/
DROP PROCEDURE [dbo].[stp_LoadClientSearch]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_LoadClientSearch]
	(
		@clientid int
	)

as


-- discretionary variables
declare @clienttype varchar (255)
declare @clientname varchar (255)
declare @clientaddress varchar (8000)
declare @clientaccountnumber varchar (255)
declare @clientssn varchar (255)
declare @clientcontacttype varchar (8000)
declare @clientcontactnumber varchar (8000)

declare @personid int
declare @personfirstname varchar (50)
declare @personfirstnameplural varchar (50)
declare @personlastname varchar (50)
declare @personssn varchar (50)
declare @personstreet varchar (50)
declare @personstreet2 varchar (50)
declare @personcity varchar (50)
declare @personstateabbreviation varchar (50)
declare @personzipcode varchar (50)
declare @personrelationship varchar (50)
declare @personaddress varchar (255)
declare @personemailaddress varchar (50)

declare @phoneid int
declare @phonetypeid int
declare @phonetypename varchar (255)
declare @phoneareacode varchar (255)
declare @phonenumber varchar (255)


-- remove any previous existance of this client from the search table
delete from tblclientsearch where clientid = @clientid


-- get persons for client
declare b_cursor cursor for
	select
		tblperson.personid,
		tblperson.firstname,
		tblperson.lastname,
		tblperson.ssn,
		tblperson.street,
		tblperson.street2,
		tblperson.city,
		tblstate.abbreviation as stateabbreviation,
		tblperson.zipcode,
		tblperson.relationship,
		tblperson.emailaddress
	from
		tblperson inner join
		tblclient on tblperson.clientid = tblclient.clientid left outer join
		tblstate on tblperson.stateid = tblstate.stateid
	where
		tblclient.clientid = @clientid
	order by
		(
			case
				when tblperson.relationship = 'prime' then
					1
				else
					0
			end
		) desc,
		tblperson.lastmodified desc

open b_cursor

fetch next from b_cursor into @personid, @personfirstname, @personlastname, @personssn, @personstreet, @personstreet2, @personcity, @personstateabbreviation, @personzipcode, @personrelationship, @personemailaddress
while @@fetch_status = 0

	begin

		-- add type
		if @clienttype is null or len(@clienttype) = 0
			begin
				set @clienttype = @personrelationship
			end
		else
			begin
				set @clienttype = @clienttype + char(13) + char(10) + @personrelationship
			end

		-- create plural first name
		if right(@personfirstname, 1) = 's'
			begin
				set @personfirstnameplural = @personfirstname + ''''
			end
		else
			begin
				set  @personfirstnameplural = @personfirstname + '''s'
			end

		-- add name
		if @clientname is null or len(@clientname) = 0
			begin
				set @clientname = @personfirstname + ' ' + @personlastname
			end
		else
			begin
				set @clientname = @clientname + char(13) + char(10) + @personfirstname + ' ' + @personlastname
			end

		-- add ssn
		if @clientssn is null or len(@clientssn) = 0
			begin
				set @clientssn = @personssn
			end
		else
			begin
				set @clientssn = @clientssn + char(13) + char(10) + @personssn
			end

		-- execute address display stored procs and return address
		exec stp_GetAddressFullForAddress @personstreet, @personstreet2, @personcity, @personstateabbreviation, @personzipcode, @address=@personaddress output


		-- replace newline chars with '|'
		set @personaddress = replace(@personaddress, char(13) + char(10), '|')


		-- add person's address to global addresses if not already there
		if @clientaddress is null or len(@clientaddress) = 0 -- nothing in global address yet
			begin
				set @clientaddress = @personaddress
			end
		else
			begin

				if charindex(@personaddress, @clientaddress) = 0 -- person address does not match any part of global address
					begin
						set @clientaddress = @clientaddress + char(13) + char(10) + @personaddress
					end
			end


		-- person's email to contact type and number
		if not @personemailaddress is null and len(@personemailaddress) > 0
			begin

				-- add contact type
				if @clientcontacttype is null or len(@clientcontacttype) = 0
					begin
						set @clientcontacttype = @personfirstnameplural + ' Email Address'
					end
				else
					begin
						set @clientcontacttype = @clientcontacttype + char(13) + char(10) + @personfirstnameplural + ' Email Address'
					end

				-- add contact number
				if @clientcontactnumber is null or len(@clientcontactnumber) = 0
					begin
						set @clientcontactnumber = @personemailaddress
					end
				else
					begin
						set @clientcontactnumber = @clientcontactnumber + char(13) + char(10) + @personemailaddress
					end

			end


		-- get phones for person
		declare c_cursor cursor for
			select
				tblphone.phoneid,
				tblphone.phonetypeid,
				tblphonetype.[name] as phonetypename,
				tblphone.areacode,
				tblphone.number
			from
				tblphone inner join
				tblpersonphone on tblphone.phoneid = tblpersonphone.phoneid inner join
				tblphonetype on tblphone.phonetypeid = tblphonetype.phonetypeid
			where
				tblpersonphone.personid = @personid

		open c_cursor

		fetch next from c_cursor into @phoneid, @phonetypeid, @phonetypename, @phoneareacode, @phonenumber
		while @@fetch_status = 0

			begin

				-- add contact type
				if @clientcontacttype is null or len(@clientcontacttype) = 0
					begin
						set @clientcontacttype = @personfirstnameplural + ' ' + @phonetypename
					end
				else
					begin
						set @clientcontacttype = @clientcontacttype + char(13) + char(10) + @personfirstnameplural + ' ' + @phonetypename
					end

				-- add contact number
				if @clientcontactnumber is null or len(@clientcontactnumber) = 0
					begin
						set @clientcontactnumber = @phoneareacode + @phonenumber
					end
				else
					begin
						set @clientcontactnumber = @clientcontactnumber + char(13) + char(10) + @phoneareacode + @phonenumber
					end

				fetch next from c_cursor into @phoneid, @phonetypeid, @phonetypename, @phoneareacode, @phonenumber

			end

		close c_cursor
		deallocate c_cursor


		fetch next from b_cursor into @personid, @personfirstname, @personlastname, @personssn, @personstreet, @personstreet2, @personcity, @personstateabbreviation, @personzipcode, @personrelationship, @personemailaddress

	end

close b_cursor
deallocate b_cursor


-- collect the account number for this client
select @clientaccountnumber = accountnumber from tblclient where clientid = @clientid


-- insert the prepared values into the tblClientSearch table
if not @clienttype is null or not @clientname is null or not @clientaccountnumber is null or not @clientssn is null or not @clientaddress is null or not @clientcontacttype is null or not @clientcontactnumber is null
	begin

		insert into
			tblclientsearch
			(
				clientid,
				type,
				[name],
				accountnumber,
				ssn,
				address,
				contacttype,
				contactnumber
			)
		values
			(
				@clientid,
				@clienttype,
				@clientname,
				@clientaccountnumber,
				@clientssn,
				@clientaddress,
				@clientcontacttype,
				@clientcontactnumber
			)

	end
GO
