SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UsersStoreUpdate]
(@UserStoreID uniqueidentifier,
@UserID uniqueidentifier,
@OnLine bit,
@StoreID uniqueidentifier,
@IsDefault bit,
@Manager bit,
@GroupID uniqueidentifier,
@LogonDate datetime,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
Declare @Default bit
if @IsDefault is null
  set @Default= 0
 else
   set @Default= @IsDefault   
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE  dbo.UsersStore
 
SET   
----UserID = @UserID, 
OnLine =   @OnLine,   Manager=@Manager,
                         StoreID =  @StoreID,IsDefault =@IsDefault, GroupID = @GroupID, LogonDate=@LogonDate,Status = ISNULL(@Status,1),  DateModified =@UpdateTime, UserModified = @ModifierID
WHERE (UserStoreID = @UserStoreID) and  (DateModified = @DateModified or DateModified is NULL)

if @IsDefault=1

update dbo.UsersStore
set IsDefault = 0
where UserID = @UserID And (UserStoreID <> @UserStoreID)


select @UpdateTime as DateModified
GO