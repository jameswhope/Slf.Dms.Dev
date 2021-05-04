DROP  Function  fn_Vici_AllowLeadStatusTransition
Go

CREATE Function fn_Vici_AllowLeadStatusTransition(@OldStatusId int,	@NewStatusId int)
Returns bit
AS
Begin    
   --protect some statuses from getting changed (9, 10, 23)  
   --limit some statutes (2,13,15,24) based on previous (1,13,15,16,17,24)
   declare @result bit
   select @result =  case when @NewStatusId in (9) then 1 -- DNC
			   when @OldStatusId in (9, 10, 23) then 0
			   when @NewStatusId in (2,13,15,24) and @OldStatusId not in (1,13,15,16,17,24) then 0
			   else 1
			   end
	Return @result
End

GO
 
