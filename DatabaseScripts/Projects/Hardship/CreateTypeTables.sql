 
DROP  Table [tblClientIncomeTypes]
CREATE TABLE [dbo].[tblClientIncomeTypes](
	[IncomeTypeID] int IDENTITY(1,1) NOT NULL,
	[IncomeTypeDescription] [varchar](50) NULL,
	[IncomeTypeShortDesc] [varchar](50) NULL,
 CONSTRAINT [PK_tblClientIncomeTypes] PRIMARY KEY CLUSTERED 
(
	[IncomeTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into tblClientIncomeTypes ([IncomeTypeDescription],[IncomeTypeShortDesc]) VALUES ('Work Income','WORKINC')
insert into tblClientIncomeTypes ([IncomeTypeDescription],[IncomeTypeShortDesc]) VALUES ('Social Security','SOCSEC')
insert into tblClientIncomeTypes ([IncomeTypeDescription],[IncomeTypeShortDesc]) VALUES ('Disability','DISAB')
insert into tblClientIncomeTypes ([IncomeTypeDescription],[IncomeTypeShortDesc]) VALUES ('Retirement/Pension','RETPEN')
insert into tblClientIncomeTypes ([IncomeTypeDescription],[IncomeTypeShortDesc]) VALUES ('Self Employed','SELFEMP')
insert into tblClientIncomeTypes ([IncomeTypeDescription],[IncomeTypeShortDesc]) VALUES ('Unemployed','UNEMP')

DROP TABLE tblClientExpenseTypes
CREATE TABLE [dbo].[tblClientExpenseTypes](
	[ExpenseTypeID] int IDENTITY(1,1) NOT NULL,
	[ExpenseTypeDescription] [varchar](50) NULL,
	[ExpenseTypeShortDesc] [varchar](50) NULL,
 CONSTRAINT [PK_tblClientExpenseTypes] PRIMARY KEY CLUSTERED 
(
	[ExpenseTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Car payment','CARPAY')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Car Insurance','CARINS')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Utilities','UTIL')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Groceries','FOOD')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Medical Insurance','MEDINS')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Medications','MEDS')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Gasoline/Transportation','TRANS')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('School Loans','SCHLOAN')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Other','OTH')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Rent','RENT')
insert into [tblClientExpenseTypes] ([ExpenseTypeDescription],[ExpenseTypeShortDesc]) VALUES ('Mortgage','MORT')


DROP TABLE tblClientMedicalConditionTypes
CREATE TABLE [dbo].[tblClientMedicalConditionTypes](
	[ConditionTypeID] int IDENTITY(1,1) NOT NULL,
	[ConditionTypeDescription] [varchar](50) NULL,
 CONSTRAINT [PK_tblClientMedicalConditionTypes] PRIMARY KEY CLUSTERED 
(
	[ConditionTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into [tblClientMedicalConditionTypes] ([ConditionTypeDescription]) VALUES ('Diabetes')
insert into [tblClientMedicalConditionTypes] ([ConditionTypeDescription]) VALUES ('Arthritis')
insert into [tblClientMedicalConditionTypes] ([ConditionTypeDescription]) VALUES ('Asthma')
insert into [tblClientMedicalConditionTypes] ([ConditionTypeDescription]) VALUES ('High Blood Pressure')
insert into [tblClientMedicalConditionTypes] ([ConditionTypeDescription]) VALUES ('High Cholesterol')
insert into [tblClientMedicalConditionTypes] ([ConditionTypeDescription]) VALUES ('Other')

DROP TABLE tblClientRelationshipTypes
CREATE TABLE [dbo].tblClientRelationshipTypes(
	[ClientRelationshipTypeID] int IDENTITY(1,1) NOT NULL,
	[ClientRelationshipTypeTypeDescription] [varchar](50) NULL,
 CONSTRAINT [PK_tblClientRelationshipTypes] PRIMARY KEY CLUSTERED 
(
	[ClientRelationshipTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Brother')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Coworker')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Daughter')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Father')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Friend')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Mother')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Other')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Client')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Sister')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Son')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Spouse')
insert into tblClientRelationshipTypes ([ClientRelationshipTypeTypeDescription]) VALUES ('Unknown')


DROP TABLE tblClientMarriageTypes
CREATE TABLE tblClientMarriageTypes(
	[MarriageTypeID] int IDENTITY(1,1) NOT NULL,
	[MarriageTypeDescription] [varchar](50) NULL,
 CONSTRAINT [PK_tblClientMarriageTypes] PRIMARY KEY CLUSTERED 
(
	[MarriageTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into tblClientMarriageTypes ([MarriageTypeDescription]) VALUES ('Married')
insert into tblClientMarriageTypes ([MarriageTypeDescription]) VALUES ('Single')
insert into tblClientMarriageTypes ([MarriageTypeDescription]) VALUES ('Divorced')
insert into tblClientMarriageTypes ([MarriageTypeDescription]) VALUES ('Windowed')