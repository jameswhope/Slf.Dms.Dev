IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetLeadCallResultTypes')
	BEGIN
		DROP  Procedure  stp_Dialer_GetLeadCallResultTypes
	END

GO

CREATE Procedure stp_Dialer_GetLeadCallResultTypes
AS
select t.*, ImgIconPath = isnull(t.IconPath,''), c.Result, c.Description
from tblLeadDialerCallResultType t
Inner join tbldialercallresulttype c on c.resultTypeId = t.ResultTypeId
order by t.taborder, t.leadresulttypeId

GO



