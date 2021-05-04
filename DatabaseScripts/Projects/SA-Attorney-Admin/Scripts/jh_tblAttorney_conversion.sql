
/* 
	Currently, if an attorney belongs to both Palmer and Seideman, they have 2 records in tblAttorney.
	These scripts will move attorney state and company information to cross-ref tables, then remove
	the duplicate attorney records.

	New tables
	1. tblCompanyStateBar
	2. tbLCompanyPhones
	--3. tblCommRecAddress
	--4. tblCommRecPhone
	6. tblAttyStates
	7. tblCompanyStatePrimary
	8. tblAgencyAddress
	9. tblAgencyAgent
	10. tblChildAgency

	New columns
	--4. tblAgency.Contact1
	--5. tblAgency.Contact2
	--6. tblAgency.IsCommRec

	Deleted Columns
	1. tblAttorney.CompanyID		Moved to tblAttyRelation
	2. tblAttorney.States			Moved to tblAttyStates
	3. tblAttorney.StateID			Obsolete
	4. tblAttorney.StatePrimary		Moved to tblCompanyStatePrimary
	5. tblAttorney.StateBarNum		Moved to tblAttyStates
	
	Deleted Tables
	1. tblCompanyAttyPivot			Not being used, has same table structure as tblAttyRelation

	New Keys
	1. tblAttorney.AttorneyID		Primary Key
	2. tblAttyRelation.AttorneyID	Foreign Key
	3. tblAttyRelation.CompanyID	Foreign Key
*/


-- Fixing type-o's
update tblAttorney set LastName = 'Fernandez' where LastName = 'Feranadez'
update tblAttorney set LastName = 'Yeager' where LastName = 'Yaeger'
update tblAttorney set LastName = 'Lashin' where LastName = 'Leshin'
update tblAttorney set FirstName = 'Christina' where FirstName = 'Christine' and LastName = 'Latta'
update tblAttorney set FirstName = 'Richard' where FirstName = 'Righard'
update tblAttorney set FirstName = 'Daniel', MiddleName = 'J.' where FirstName = 'J. Daniel'
update tblAttorney set FirstName = 'Jeffrey' where FirstName = 'Jeffery'
update tblAttorney set FirstName = 'Terrance' where FirstName = 'Terrence'


declare @AttorneyID int, 
		@AttorneyIDToKeep int,
		@CompanyID int, 
		@States varchar(30), 
		@StatePrimary bit, 
		@FirstName varchar(30), 
		@LastName varchar(30)

declare cur cursor for select AttorneyID, CompanyID, States, StatePrimary, FirstName, LastName from tblAttorney 
open cur
fetch next from cur into @AttorneyID, @CompanyID, @States, @StatePrimary, @FirstName, @LastName

while @@fetch_status = 0 begin

	select @AttorneyIDToKeep = min(AttorneyID) 
	from tblAttorney 
	where FirstName = @FirstName
	and LastName = @LastName

	-- Attorney/company relations
	if not exists (select 1 from tblAttyRelation where AttorneyID = @AttorneyIDToKeep and CompanyID = @CompanyID) begin
		insert tblAttyRelation (AttorneyID, CompanyID, AttyRelation,CreatedBy,LastModifiedBy) 
		values (@AttorneyIDToKeep, @CompanyID, 'Associated',820,820)
	end
	
	-- Adding states the attorney belongs to
	insert tblAttyStates (AttorneyID, [State])
	select AttorneyID, [State]
	from (
		select @AttorneyIDToKeep [AttorneyID], ltrim(value) [State] from dbo.SplitStr(@States,',')
	) t
	where not exists (
		select 1 from tblAttyStates s where s.AttorneyID = t.AttorneyID and s.State = t.State)

	-- Is this attorney a state primary?
	if @StatePrimary = 1 begin
		insert tblCompanyStatePrimary (AttorneyID, CompanyID, [State])
		select AttorneyID, CompanyID, [State]
		from (
			select @AttorneyIDToKeep [AttorneyID], @CompanyID [CompanyID], ltrim(value) [State] from dbo.SplitStr(@States,',')
		) t
		where not exists (
			select 1 from tblCompanyStatePrimary p where p.CompanyID = t.CompanyID and p.State = t.State)
	end

	-- Cleanup, remove duplicate attorney record
	if @AttorneyID <> @AttorneyIDToKeep begin
		delete from tblAttyRelation where AttorneyID = @AttorneyID
		delete from tblAttyStates where AttorneyID = @AttorneyID
		delete from tblCompanyStatePrimary where AttorneyID = @AttorneyID
		delete from tblAttorney where AttorneyID = @AttorneyID
	end

	fetch next from cur into @AttorneyID, @CompanyID, @States, @StatePrimary, @FirstName, @LastName
end

close cur
deallocate cur


-- Moved to tblAttRelation
if exists (select 1 from syscolumns where id = object_id('tblAttorney') and name = 'CompanyID') begin
	alter table tblAttorney drop column CompanyID
end

-- Moved to tblAttyStates
if exists (select 1 from syscolumns where id = object_id('tblAttorney') and name = 'States') begin
	alter table tblAttorney drop column States
end

-- Obsolete
if exists (select 1 from syscolumns where id = object_id('tblAttorney') and name = 'StateID') begin
	alter table tblAttorney drop column StateID
end

-- Moved to tblCompanyStatePrimary
if exists (select 1 from syscolumns where id = object_id('tblAttorney') and name = 'StatePrimary') begin
	alter table tblAttorney drop column StatePrimary
end

-- Drop unused table tblCompanyAttyPivot
if not object_id('tblCompanyAttyPivot') is null begin
	drop table tblCompanyAttyPivot
end