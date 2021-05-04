if exists (select * from sysobjects where name = 'stp_InsertShadowCommission')
	drop procedure stp_InsertShadowCommission
go


CREATE PROCEDURE [dbo].[stp_InsertShadowCommission]
(
	@commrecid int,
	@display nvarchar(50),
	@bankaccountnumber nvarchar(50),
	@bankroutingnumber nvarchar(50),
	@accounttype nvarchar(1),
	@transferamount money,
	@ispersonal bit,
	@companyid int,
	@trustid int
)

AS


INSERT INTO tblNachaRegister2
(
	NachaFileId,
	[Name],
	AccountNumber,
	RoutingNumber,
	[Type],
	Amount,
	IsPersonal,
	CommRecId,
	CompanyID,
	Created,
	ShadowStoreId,
	RegisterId,
	RegisterPaymentID,
	TrustID,
	Flow
)
VALUES
(
	-1,
	@display,
	@bankaccountnumber,
	@bankroutingnumber,
	isnull(@accounttype, 'C'),
	round(@transferamount, 2), -- should always be a positive amount
	@ispersonal,
	@commrecid,
	@companyid,
	getdate(),
	null,
	null,
	null,
	@trustid,
	'debit' -- debit GCA and credit recipient
)

RETURN scope_identity()