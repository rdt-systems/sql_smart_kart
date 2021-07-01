SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_RegisterKeysUpdate]
(@RegisterKeyID int, 
@ActionID nvarchar(50), 
@ActionKey nvarchar(10), 
@ShiftType smallint, 
@IsAction bit, 
@IsButton bit, 
@Status smallint, 
@DateModified datetime,	
@ModifierID uniqueidentifier 
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE [dbo].[RegisterKeys]
   SET [ActionID] = @ActionID
      ,[ActionKey] = @ActionKey
      ,[ShiftType] = @ShiftType
      ,[IsAction] = @IsAction
      ,[IsButton] = @IsButton
      ,[Status] = ISNULL(@Status,1)
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID

 WHERE	[RegisterKeyID] = @RegisterKeyID --AND 
		--(DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO