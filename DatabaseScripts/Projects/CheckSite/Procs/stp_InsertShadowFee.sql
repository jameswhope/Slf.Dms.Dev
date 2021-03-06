if exists (select * from sysobjects where name = 'stp_InsertShadowFee')
	drop procedure stp_InsertShadowFee
go


CREATE PROCEDURE [dbo].[stp_InsertShadowFee]
(
	@registerpaymentid int
)

AS

declare @clientid int
declare @accountnumber nvarchar(15)
declare @companyid int
declare @registerid int
declare @amount money
declare @trustid int
declare @name varchar(50)


SELECT
	@clientid = c.ClientID,
	@accountnumber = c.AccountNumber,
	@companyid = c.CompanyID,
	@registerid = r.RegisterID,
	@amount = rp.Amount,
	@trustid = c.TrustID,
	@name = cp.ControlledAccountName
FROM
	tblRegisterPayment as rp
	inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
	inner join tblClient as c on c.ClientID = r.ClientID
	inner join tblCompany cp on cp.CompanyID = c.CompanyID
WHERE
	rp.RegisterPaymentID = @registerpaymentid



INSERT INTO tblNachaRegister2
(
	Amount,
	CompanyID,
	ShadowStoreId,
	RegisterId,
	RegisterPaymentID,
	ClientID,
	TrustID,
	IsPersonal,
	[Name],
	Flow
)
VALUES
(
	@amount,
	@companyid,
	@accountnumber,
	@registerid,
	@registerpaymentid,
	@clientid,
	@trustid,
	0,
	@name,
	'debit' -- debit shadow store and credit GCA
)