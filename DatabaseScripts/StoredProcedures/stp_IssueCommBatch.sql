/****** Object:  StoredProcedure [dbo].[stp_IssueCommBatch]    Script Date: 11/19/2007 15:27:23 ******/
DROP PROCEDURE [dbo].[stp_IssueCommBatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_IssueCommBatch]


as

exec stp_IssueCommBatch_S
exec stp_IssueCommBatch_P
GO
