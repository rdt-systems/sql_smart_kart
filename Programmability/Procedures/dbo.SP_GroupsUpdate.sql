SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GroupsUpdate]
(@GroupID uniqueidentifier,
@GroupName nvarchar(50),
@IsSystem bit,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.Groups
SET              GroupName = dbo.CheckString(@GroupName), IsSystem = @IsSystem, Status = @Status, DateModified = @UpdateTime, UserModified = @ModifierID
WHERE     (GroupID = @GroupID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO