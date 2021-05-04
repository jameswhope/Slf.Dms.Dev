IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetValidTaskTypeList')
	BEGIN
		DROP  Procedure  stp_GetValidTaskTypeList
	END

GO

CREATE Procedure stp_GetValidTaskTypeList
(
	@UserId			int	=null,
	@UserGroupId	int =null,
	@MatterTypeId	int =null 

)
AS
BEGIN
	Select t.* 
	from tblTaskType t left outer join tblMatterTypeTaskXRef r on t.taskTypeID = r.taskTypeID
	Where r.MatterTypeId=@MatterTypeId
	Order by [name]
/*

IF @MatterTypeId=1 

BEGIN

(select * from tblTaskType t where  t.TaskTypeCategoryId=0 )
union

(select * from tblTaskType t where  t.TaskTypeCategoryId=9  )

order by TaskTypeCategoryId,[Name]

END

ELSE

(select * from tblTaskType t  )
union

(select * from tblTaskType t  )

order by TaskTypeCategoryId,[Name]

*/
END




GRANT EXEC ON stp_GetValidTaskTypeList TO PUBLIC

GO


