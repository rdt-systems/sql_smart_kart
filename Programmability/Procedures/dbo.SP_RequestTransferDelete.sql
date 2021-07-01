SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RequestTransferDelete]
(@RequestTransferID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 


Update dbo.RequestTransfer
SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE   RequestTransferID=@RequestTransferID
GO