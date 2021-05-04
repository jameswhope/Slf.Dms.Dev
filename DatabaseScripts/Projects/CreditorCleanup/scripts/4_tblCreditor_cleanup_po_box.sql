
update tblcreditor
set street = replace(street,'po box','P.O. Box')
where street like '%po%box%'
and len(street) < 49

update tblcreditor
set street = replace(street,'po  box','P.O. Box')
where street like '%po  box%'

update tblcreditor
set street = replace(street,'Post Office Box','P.O. Box')
where street like '%Post Office Box%'

update tblcreditor
set street = replace(street,'po. box','P.O. Box')
where street like '%po.%box%'

update tblcreditor
set street = replace(street,'pobox','P.O. Box')
where street like '%pobox%'

update tblcreditor
set street = replace(street,'po.box','P.O. Box')
where street like '%po.box%' 

update tblcreditor
set street = replace(street,'p.o box','P.O. Box')
where street like '%p.o box%' 

update tblcreditor set name = replace(name,'\','') where name like '%\%'
update tblcreditor set street = replace(street,'\','') where street like '%\%'
update tblcreditor set street2 = replace(street2,'\','') where street2 like '%\%'
update tblcreditor set city = replace(city,'\','') where city like '%\%'