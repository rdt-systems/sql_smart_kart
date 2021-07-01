SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_RegisterKeysInsert]
(@RegisterKeyID int, 
@ActionID nvarchar(50), 
@ActionKey nvarchar(10), 
@ShiftType smallint, 
@IsAction bit, 
@IsButton bit, 
@Status smallint, 
@ModifierID uniqueidentifier 
)

as
INSERT INTO [dbo].[RegisterKeys]
           ([RegisterKeyID]
           ,[ActionID]
           ,[ActionKey]
           ,[ShiftType]
           ,[IsAction]
           ,[IsButton]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           ,[UserModified])
     VALUES
           (@RegisterKeyID, 
           @ActionID, 
           @ActionKey,
           @ShiftType, 
           @IsAction,
           @IsButton, 
           isnull(@Status,1),
           dbo.GetLocalDATE(), 
           @ModifierID,
           dbo.GetLocalDATE(),
           @ModifierID )
GO