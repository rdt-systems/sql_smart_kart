SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GroupsInsert]
( @GroupID uniqueidentifier,
@GroupName nvarchar(50),
@IsSystem bit,
@Status smallint,
@ModifierID uniqueidentifier)
AS
INSERT INTO dbo.Groups
                      (GroupID, GroupName, IsSystem, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@GroupID, dbo.CheckString(@GroupName),@IsSystem, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO