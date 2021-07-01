SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UsersStoreInsert]
(@UserStoreID uniqueidentifier,
@UserID uniqueidentifier,
@OnLine bit,
@StoreID uniqueidentifier,
@IsDefault bit,
@Manager bit,
@GroupID uniqueidentifier,
@LogonDate datetime,
@Status smallint,
@ModifierID uniqueidentifier)
AS

if (Select COUNT(*) from UsersStore where UserID=@UserID)>0
BEGIN
	UPDATE  dbo.UsersStore
	SET   
	------UserID = @UserID, 
	OnLine =   @OnLine,   Manager=@Manager,
							 StoreID =  @StoreID,IsDefault =@IsDefault, GroupID = @GroupID, LogonDate=@LogonDate,Status = ISNULL(@Status, 1),  DateModified =dbo.GetLocalDATE(), UserModified = @ModifierID
	WHERE (@UserID = @UserID) AND (UserStoreID = @UserStoreID)
END
ELSE
	 Insert Into   dbo.UsersStore (UserStoreID, UserID,       OnLine,               StoreID,     IsDefault, Manager,  GroupID,LogonDate,  Status, DateCreated,  UserCreated,  DateModified, UserModified)

								Values(@UserStoreID, @UserID,    @OnLine ,      @StoreID, @IsDefault, @Manager,  @GroupID,@LogonDate,1,       dbo.GetLocalDATE(),     @ModifierID,      dbo.GetLocalDATE(), @ModifierID )
GO