/****** Object:  StoredProcedure [dbo].[stp_QueryCache_PopulateAll]    Script Date: 11/19/2007 15:27:33 ******/
DROP PROCEDURE [dbo].[stp_QueryCache_PopulateAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryCache_PopulateAll]
as

exec stp_QueryCache_PopulateProjectedCommission
GO
