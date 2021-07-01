SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PPCUsersInsert]
(@PPCUserID uniqueidentifier,
@UserName nvarchar(50),
@Password nvarchar(50),
@AssociatedUserID uniqueidentifier,
@AssociatedResellerID uniqueidentifier,
@Type Int,
@ModifierID uniqueidentifier,
@Status smallint)
AS INSERT INTO dbo.PPCUsers
			(PPCUserID,
			 UserName, 
			 Password,
			 AssociatedUserID,
			 AssociatedResellerID,
			 [Type], 
			 Status, 
			 DateCreated, 
			 UserCreated, 
			 DateModified, 
			 UserModified)
VALUES     (@PPCUserID, 
		    dbo.CheckString(@UserName),
		    @Password,
			@AssociatedUserID,
			@AssociatedResellerID,
			@Type,
		    1, 
			dbo.GetLocalDATE(), 
			@ModifierID, 
			dbo.GetLocalDATE(),
			@ModifierID)
GO