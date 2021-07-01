SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RequestTransferEntryDelete]
(@RequestTransferEntryID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
Update dbo.RequestTransferEntry
SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE   RequestTransferEntryID=@RequestTransferEntryID
GO