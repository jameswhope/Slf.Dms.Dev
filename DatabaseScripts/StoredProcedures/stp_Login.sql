/****** Object:  StoredProcedure [dbo].[stp_Login]    Script Date: 11/19/2007 15:27:24 ******/
DROP PROCEDURE [dbo].[stp_Login]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Login]
	(
		@username varchar (255),
		@password varchar (255)
	)

as

select * from tbluser where username = @username and [password] = @password
GO
