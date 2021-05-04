IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getProductSourceFromDNIS')
	BEGIN
		DROP  Procedure  stp_getProductSourceFromDNIS
	END

GO

CREATE Procedure stp_getProductSourceFromDNIS
@CallIDKey varchar(50)
AS
BEGIN

declare @productcode varchar(50)

select @productcode = null

select top 1 @productcode = dnis from tblcalldnis where callidkey = @CallIdKey

select top 1 p.productid, p.cost, p.defaultsourceid from tblleadproducts p
where p.active = 1
and cast(convert(varchar ,getdate(), 110)  + ' ' + isnull(p.starttime,'12:00 AM') as datetime) < = getdate()  and cast(convert(varchar ,getdate(), 110)  + ' ' + isnull(p.endtime, '11:59:59.999 PM') as datetime) > getdate()   
and p.productcode=@productcode
and p.IsDNIS = 1


END

GO


