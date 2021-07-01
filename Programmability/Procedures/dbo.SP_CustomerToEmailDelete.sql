SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerToEmailDelete]
(@CustomerToEmailID uniqueidentifier,
   @ModifierID uniqueidentifier)

AS UPDATE dbo.CustomerToEmail
                    
SET      Status  = -1,  DateModified = dbo.GetLocalDATE()

WHERE CustomerToEmailID=@CustomerToEmailID

UPDATE dbo.Email
SET   Status  = -1,  DateModified = dbo.GetLocalDATE()
Where EmailID=(SELECT EmailID FROM dbo.CustomerToEmail WHERE CustomerToEmailID=@CustomerToEmailID)
GO