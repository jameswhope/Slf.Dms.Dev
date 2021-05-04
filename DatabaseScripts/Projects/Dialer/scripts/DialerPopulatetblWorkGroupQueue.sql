delete from tblDialerWorkGroupQueue

insert into  tblDialerWorkGroupQueue (QueueName, Extension, Active, MaxLines, MaxAttempts, CallStartDate, CallStartTime, CallEndTime, DialerGroupId, CallPerUserRatio)
values('Settlement Processing', '634', 1, 100, 0, GetDate(), '1900-01-01 08:00:00.000', '1900-01-01 16:50:00.000', 1, 2)


insert into  tblDialerWorkGroupQueue (QueueName, Extension, Active, MaxLines, MaxAttempts, CallStartDate, CallStartTime, CallEndTime, DialerGroupId, CallPerUserRatio. MaxAttemptsPerDay)
values('CID Dialer Workgroup', '613', 1, 100, 0, GetDate(), '1900-01-01 08:00:00.000', '1900-01-01 17:55:00.000', 1, 1, 1)

