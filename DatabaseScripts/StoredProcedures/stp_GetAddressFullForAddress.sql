/****** Object:  StoredProcedure [dbo].[stp_GetAddressFullForAddress]    Script Date: 11/19/2007 15:27:04 ******/
DROP PROCEDURE [dbo].[stp_GetAddressFullForAddress]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetAddressFullForAddress]
	(
		@street varchar (255),
		@street2 varchar (255),
		@city varchar (255),
		@state varchar (255),
		@zipcode varchar (255),
		@address varchar (255) output
	)

as


-- initialize the returned address to an empty string (so we don't have to deal with null values)
set @address = ''


if len(@street) > 0
	begin
		set @address = @street
	end

if len(@street2) > 0
	begin
		if len(@address) > 0
			begin
				set @address = @address + char(13) + char(10) + @street2
			end
		else
			begin
				set @address = @street2
			end
	end

if len(@city) > 0
	begin
		if len(@address) > 0
			begin
				set @address = @address + char(13) + char(10) + @city
			end
		else
			begin
				set @address = @city
			end
	end

if len(@state) > 0
	begin
		if len(@city) > 0
			begin
				set @address = @address + ', ' + @state
			end
		else
			begin
				if len(@address) > 0
					begin
						set @address = @address + char(13) + char(10) + @state
					end
				else
					begin
						set @address = @state
					end
			end
	end

if len(@zipcode) > 0
	begin
		if len(@state) > 0
			begin
				set @address = @address + ' ' + @zipcode
			end
		else if len(@city) > 0
			begin
				set @address = @address + ', ' + @zipcode
			end
		else
			begin
				if len(@address) > 0
					begin
						set @address = @address + char(13) + char(10) + @zipcode
					end
				else
					begin
						set @address = @zipcode
					end
			end
	end
GO
