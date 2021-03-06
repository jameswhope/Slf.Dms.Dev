/****** Object:  StoredProcedure [dbo].[stp_GetCommPaysForPayment]    Script Date: 11/19/2007 15:27:06 ******/
DROP PROCEDURE [dbo].[stp_GetCommPaysForPayment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetCommPaysForPayment]
	(
		@registerpaymentid int
	)

as


select
	tblcommpay.*,
	tblcommstruct.commscenid,
	tblcommstruct.commrecid,
	tblcommstruct.parentcommrecid,
	tblcommstruct.[order] as commstructorder,
	tblcommrec.commrectypeid,
	tblcommrec.display,
	tblcommrectype.[name] as commrectypename
from
	tblcommpay inner join
	tblcommstruct on tblcommpay.commstructid = tblcommstruct.commstructid inner join
	tblcommrec on tblcommstruct.commrecid = tblcommrec.commrecid inner join
	tblcommrectype on tblcommrec.commrectypeid = tblcommrectype.commrectypeid
where
	tblcommpay.registerpaymentid = @registerpaymentid
GO
