SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_LookAccountDelete]
(@LookAccountID uniqueidentifier,
@CustomerID nvarchar(50),
@ModifierID uniqueidentifier)
AS UPDATE  dbo.LookAccount


       SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE LookAccountID=@LookAccountID
GO