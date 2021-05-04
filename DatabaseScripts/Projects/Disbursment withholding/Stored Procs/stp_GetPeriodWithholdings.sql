IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPeriodWithholdings')
	BEGIN
		DROP  Procedure  stp_GetPeriodWithholdings
	END
GO
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 08/11/2011
-- Description:	Amounts withheld for the period
-- =============================================
CREATE PROCEDURE stp_GetPeriodWithholdings 
	-- Add the parameters for the stored procedure here
	@sDate datetime = NULL, 
	@eDate datetime = NULL
AS
BEGIN
	SET NOCOUNT ON;
--Test Data*************************
--DECLARE @sDate DATETIME 
--DECLARE @eDate DATETIME 
--************************************

IF @sDate IS NULL BEGIN
SET                @sDate = CAST(CAST(GETDATE() AS VARCHAR(12)) + ' 12:00:01 AM' AS DATETIME) END
ELSE BEGIN
SET				  @sDate = CAST(CAST(@sDate AS VARCHAR(12)) + ' 12:00:01 AM' AS DATETIME) END
IF @eDate IS NULL BEGIN
SET                @eDate = CAST(CAST(@sDate AS VARCHAR(12)) + ' 11:59:59 PM' AS DATETIME) END
ELSE BEGIN
SET				  @eDate = CAST(CAST(@eDate AS VARCHAR(12)) + ' 11:59:59 PM' AS DATETIME) END


                             SELECT        NachaRegisterID, DateWithheld, [Name], OriginalAmount, AmountWithheld, Amount, RoutingNumber, AccountNumber, WithHeldBy, WithheldFrom, 
                                                       OriginalNachaRegisterID
                              FROM            (SELECT        nr.NachaRegisterId, nr.DateWithheld, nr.Name, nr.OriginalAmount, nr.AmountWithheld, nr.Amount, nr.RoutingNumber, nr.accountnumber, 
                                                                                  u.FirstName + ' ' + u.lastname[WithheldBy], nr.WithheldFrom, nr.OriginalNachaRegisterID
                                                        FROM            tblNachaRegister nr JOIN
                                                                                  tblUser u ON u.UserID = nr.WithheldBy
                                                        WHERE        nr.PayoutWithheld = 1 AND nr.DateWithheld BETWEEN @sDate AND @eDate AND AmountWithheld > 0
                                                        UNION ALL
                                                        SELECT        nr.NachaRegisterId, nr.DateWithheld, nr.Name, nr.OriginalAmount, nr.AmountWithheld, nr.Amount, nr.RoutingNumber, nr.accountnumber, 
                                                                                 u.FirstName + ' ' + u.lastname[WithheldBy], nr.WithheldFrom, nr.OriginalNachaRegisterID
                                                        FROM            tblNachaRegister2 nr JOIN
                                                                                 tblUser u ON u.UserID = nr.WithheldBy
                                                        WHERE        nr.PayoutWithheld = 1 AND AmountWithheld > 0) w 
                             ORDER BY   Name, DateWithheld
END
GO
/*
GRANT EXEC ON stp_GetPeriodWithholdings TO PUBLIC
GO
*/

