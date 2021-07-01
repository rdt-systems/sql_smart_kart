SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailDelete]
(@EmailID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.Email
SET              Status = -1, DateModified = dbo.GetLocalDATE()
WHERE  EmailID = @EmailID
GO