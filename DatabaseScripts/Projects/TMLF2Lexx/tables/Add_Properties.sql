
if not exists(Select * from tblProperty where name = 'Mossler_Seideman_Debt')
insert into tblproperty(PropertyCategoryID,	[Name],	[Display], [Value],	[Type],	[Description],	Created,	CreatedBy,	LastModified,	LastModifiedBy)
values(13,	'Mossler_Seideman_Debt', 'Mossler to Seideman Debt'	, 60000.00,	'Month', 'Debt owned by Mossler to Seideman', GetDate(), 1827, GetDate(), 1827)

if not exists(Select * from tblProperty where name = 'Mossler_Lexxiom_Debt')
insert into tblproperty(PropertyCategoryID,	[Name],	[Display], [Value],	[Type],	[Description],	Created,	CreatedBy,	LastModified,	LastModifiedBy)
values(13,	'Mossler_Lexxiom_Debt', 'Mossler to Lexxiom Debt'	, 30000.00,	'Day', 'Debt owned by Mossler to Lexxiom', GetDate(), 1827, GetDate(), 1827)
