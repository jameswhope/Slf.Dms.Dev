
create table tblPotentialRegisterTmp
(
	RegisterID int identity(1,1) not null,
	ClientID int not null,
	TransactionDate datetime not null,
	Amount money not null,
	IsFullyPaid bit not null,
	EntryTypeID int not null,
	EntryTypeOrder int,
	Fee bit not null,
	--Void datetime,
	--Bounce datetime,
	Hold datetime,
	[Clear] datetime,
	AdjustedRegisterID int,
	FeeMonth int,
	FeeYear int,
	AchMonth int,
	AchYear int
	
	CONSTRAINT [PK_tblPotentialRegisterTmp] PRIMARY KEY CLUSTERED 
	(
		[RegisterID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
)