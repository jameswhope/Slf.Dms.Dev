
CREATE TABLE tblCreditorTotals
(
	[NoCreditors] [int] NOT NULL,
	[Date] [datetime] NOT NULL DEFAULT (getdate()),
	[ValidatedOnly] [bit] NOT NULL DEFAULT ((0))
) 