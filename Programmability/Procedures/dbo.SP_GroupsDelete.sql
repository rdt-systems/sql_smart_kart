SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GroupsDelete]
(@GroupID uniqueidentifier,
@ModifierID uniqueidentifier)
AS
Update Groups
     SET       Status = -1 ,  DateModified = dbo.GetLocalDATE() , UserModified = @ModifierID
WHERE  GroupID = @GroupID
GO