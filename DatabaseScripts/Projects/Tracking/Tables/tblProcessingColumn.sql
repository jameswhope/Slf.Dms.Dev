IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblProcessingColumn')
	BEGIN
		DROP  Table tblProcessingColumn
	END
GO

CREATE TABLE [dbo].[tblProcessingColumn](
	[NegotiationColumnID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Path] [nvarchar](100) NOT NULL,
	[ImagePath] [nvarchar](100) NOT NULL,
	[OverImagePath] [nvarchar](100) NOT NULL,
	[Height] [int] NOT NULL,
	[Width] [int] NOT NULL
) ON [PRIMARY]

SET IDENTITY_INSERT tblProcessingColumn ON
INSERT INTO tblProcessingColumn ([NegotiationColumnID],[Name],[Path],[ImagePath],[OverImagePath],[Height],[Width]) VALUES (1, 'Home','~/processing/Default.aspx','~/processing/images/hometab_off.png','~/processing/images/hometab_on.png', 25, 60)
INSERT INTO tblProcessingColumn ([NegotiationColumnID],[Name],[Path],[ImagePath],[OverImagePath],[Height],[Width]) VALUES (2, 'Processing','~/processing/processing/Default.aspx','~/processing/images/processingtab_off.png','~/processing/images/processingtab_on.png', 25, 97)
INSERT INTO tblProcessingColumn ([NegotiationColumnID],[Name],[Path],[ImagePath],[OverImagePath],[Height],[Width]) VALUES (3, 'Email','~/processing/email/Default.aspx','~/processing/images/emailtab_off.png','~/processing/images/emailtab_on.png', 25, 61)
INSERT INTO tblProcessingColumn ([NegotiationColumnID],[Name],[Path],[ImagePath],[OverImagePath],[Height],[Width]) VALUES (5, 'Calendar','~/processing/calendar/Default.aspx','~/processing/images/calendartab_off.png','~/processing/images/calendartab_on.png', 25, 76)
SET IDENTITY_INSERT tblProcessingColumn OFF