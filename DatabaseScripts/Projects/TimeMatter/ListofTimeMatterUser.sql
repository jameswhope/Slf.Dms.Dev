select distinct staff, first_name
,middle_init
,last_name from  TIMEMATTERS.TIMEMATTERS.tm8user.userid 
where staff <>''
and first_name <> 'Court'
order by staff