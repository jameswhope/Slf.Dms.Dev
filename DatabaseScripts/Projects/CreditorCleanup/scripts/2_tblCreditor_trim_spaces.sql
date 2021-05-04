
update tblcreditor 
set name = rtrim(ltrim(name)), street = rtrim(ltrim(street)), street2 = rtrim(ltrim(street2)), city = rtrim(ltrim(city)), zipcode = rtrim(ltrim(zipcode))
where (name like ' %' or street like ' %' or street2 like ' %' or city like ' %' or zipcode like ' %')

update tblcreditorgroup 
set [name] = replace([name],char(160),'')
where charindex(char(160),[name]) > 0

update tblcreditorgroup 
set [name] = replace([name],'&nbsp;','')
where charindex('&nbsp;',[name]) > 0

update tblcreditor
set [name] = replace([name],char(160),'')
where charindex(char(160),[name]) > 0

update tblcreditor
set [name] = replace([name],'&nbsp;','')
where charindex('&nbsp;',[name]) > 0