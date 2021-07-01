SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_RegisterKeysDelete]
(@RegisterKeyID int, 
@ModifierID uniqueidentifier 
)
AS

UPDATE [dbo].[RegisterKeys]
   SET [Status] = -1
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID

 WHERE	[RegisterKeyID] = @RegisterKeyID
GO