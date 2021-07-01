SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UsersInsert]
(@UserId uniqueidentifier,
@UserName nvarchar(50),
@Password nvarchar(50),
@UserFName nvarchar(50),
@UserLName nvarchar(50),
@Address nvarchar(4000),
@HomePhoneNumber nvarchar(50),
@WorkPhoneNumber nvarchar(50),
@Fax nvarchar(50),
@Email nvarchar(50),
@ZipCode nvarchar(50),
@IsSuperAdmin bit,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.Users
                      (UserId,UserName,[password], UserFName, UserLName, Address, HomePhoneNumber, WorkPhoneNumber, Fax, Email, ZipCode, IsSuperAdmin,  Status, DateCreated, UserCreated, 
                      DateModified, UserModified)
VALUES     (@UserId,@UserName,@Password, @UserFName, @UserLName, @Address, @HomePhoneNumber, @WorkPhoneNumber, @Fax, @Email, @ZipCode, @IsSuperAdmin, 1, dbo.GetLocalDATE(), 
                      @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO