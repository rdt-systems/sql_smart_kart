SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UsersUpdate]
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
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE  dbo.Users         
SET     UserName = @UserName,[password]=@password, UserFName = @UserFName, UserLName= @UserLName, Address= @Address, HomePhoneNumber =@HomePhoneNumber,WorkPhoneNumber = @WorkPhoneNumber, 
            Fax = @Fax, Email = @Email, ZipCode = @ZipCode, IsSuperAdmin= @IsSuperAdmin, Status=  ISNULL(@Status, 1),     UserModified=  @ModifierID,      DateModified =@UpdateTime

WHERE  (UserId= @UserId) and  (DateModified = @DateModified or DateModified is NULL)

--if @IsSuperAdmin=1
--begin
--	update dbo.UsersStore
--	SET  Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
--	WHERE UserId= @UserId 
--end

select @UpdateTime as DateModified
GO