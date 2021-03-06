/****** Object:  StoredProcedure [dbo].[stp_GetCommChargebacksForPayment]    Script Date: 11/19/2007 15:27:06 ******/
DROP PROCEDURE [dbo].[stp_GetCommChargebacksForPayment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetCommChargebacksForPayment]
	(
		@registerpaymentid int
	)

as


select
	tblcommchargeback.*,
	tblcommstruct.commscenid,
	tblcommstruct.commrecid,
	tblcommstruct.parentcommrecid,
	tblcommstruct.[order] as commstructorder,
	tblcommrec.commrectypeid,
	tblcommrec.display,
	tblcommrectype.[name] as commrectypename
from
	tblcommchargeback inner join
	tblcommstruct on tblcommchargeback.commstructid = tblcommstruct.commstructid inner join
	tblcommrec on tblcommstruct.commrecid = tblcommrec.commrecid inner join
	tblcommrectype on tblcommrec.commrectypeid = tblcommrectype.commrectypeid
where
	tblcommchargeback.registerpaymentid = @registerpaymentid
GO
