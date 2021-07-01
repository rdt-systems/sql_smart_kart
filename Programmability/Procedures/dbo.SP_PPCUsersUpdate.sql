SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PPCUsersUpdate]
(@PPCUserID uniqueidentifier,
@UserName nvarchar(50),
@Password nvarchar(50),
@AssociatedUserID uniqueidentifier,
@AssociatedResellerID uniqueidentifier,
@Type int,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.PPCUsers

SET 
UserName= dbo.CheckString(@UserName),
Password= @Password,
AssociatedUserID=@AssociatedUserID,
AssociatedResellerID=@AssociatedResellerID,
[Type]=@Type,
Status=ISNULL(@Status,1),
DateModified=@UpdateTime,
UserModified= @ModifierID


WHERE (PPCUserID = @PPCUserID) AND 
      (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified
GO