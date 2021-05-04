
-- allow nulls in column, null means this is pre-creditor group release entry
alter table tblcreditor alter column Validated bit null
go

-- only new creditors added after the release will be flagged as needing approval
update tblcreditor set validated = null where validated = 0
go