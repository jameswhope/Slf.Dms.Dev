
--new values

--old 155
update tblproperty 
set [value] = 165, lastmodified = getdate(), lastmodifiedby = 820
where [name] = 'EnrollmentDepositMinimum'

--old .012
update tblproperty 
set [value] = .02, lastmodified = getdate(), lastmodifiedby = 820
where [name] = 'EnrollmentDepositPercentage' 

--insert tblproperty (propertycategoryid,name,display,nullable,multi,value,type,description,created,createdby,lastmodified,lastmodifiedby)
--values (1,'EnrollmentDepositPercentageMax','EnrollmentDepositPercentageMax',0,0,.035,'Percentage','Max percentage used to determining nominal deposits and deposit range.',getdate(),820,getdate(),820)

--insert tblproperty (propertycategoryid,name,display,nullable,multi,value,type,description,created,createdby,lastmodified,lastmodifiedby)
--values (1,'EnrollmentDepositCurrentPct','EnrollmentDepositCurrentPct',0,0,.032,'Percentage','This is an estimate of the clients currently monthly percentage they are paying.',getdate(),820,getdate(),820)
