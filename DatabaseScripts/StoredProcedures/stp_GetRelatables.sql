/****** Object:  StoredProcedure [dbo].[stp_GetRelatables]    Script Date: 11/19/2007 15:27:15 ******/
DROP PROCEDURE [dbo].[stp_GetRelatables]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetRelatables]
	(
		@relationtypeid int,
		@dependencyid int	--ClientID when relatable to client
							--CreditorID for contact
							
	)
as
declare @table varchar(50)


declare @select varchar(8000)
declare @join varchar(8000)
declare @where varchar(8000)

set @join=(select [table] from tblrelationtype where relationtypeid=@relationtypeid)

if @join='tblClient' begin
	set @join = @join + ' c inner join tblperson p on c.primarypersonid=p.personid'
	set @select = 'c.clientid as RelationID, p.firstname [First Name], p.LastName [Last Name], p.SSN'
	set @where = 'c.clientid=' + convert(varchar, @dependencyid)
end else if @join='tblAccount' begin
	set @join = @join + ' a inner join tblcreditorinstance ci on a.currentcreditorinstanceid=ci.creditorinstanceid 
		inner join tblcreditor c on ci.creditorid=c.creditorid'
	set @select = 'a.accountid as RelationID, c.name [Creditor], ci.accountnumber [Account Number],ci.referencenumber [Reference Number]'
	set @where = 'a.clientid=' + convert(varchar, @dependencyid)
end else if @join='tblContact' begin
	set @join = @join + ' c'
	set @select = 'c.contactid as RelationID, c.firstname [First Name], c.lastname [Last Name], c.EmailAddress Email'
	set @where = 'c.creditorid=' + convert(varchar, @dependencyid)
end else if @join='tblRegister' begin
	set @join = @join + ' r inner join tblentrytype et on r.entrytypeid=et.entrytypeid'
	set @select = 'r.registerid as RelationID, et.Name [Entry Type], r.transactiondate [Date] , r.amount [Amount]'
	set @where = 'r.clientid=' + convert(varchar, @dependencyid)
end else if @join='tblRegisterPayment' begin
	set @join = @join + ' rp inner join tblregister r on rp.feeregisterid=r.registerid inner join tblentrytype et on r.entrytypeid=et.entrytypeid'
	set @select = 'rp.registerpaymentid as RelationID, et.Name [Fee Type], rp.paymentdate [Date], rp.amount [Amount]'
	set @where = 'r.clientid=' + convert(varchar, @dependencyid)
end

if len(@select)>0
	exec ('select ' + @select + ' from ' + @join + ' where ' + @where)
else
	select 1 as ID, 'Add to stp_GetRelatables' as ToImplement
GO
