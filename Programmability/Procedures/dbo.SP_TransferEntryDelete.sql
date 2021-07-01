SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferEntryDelete]
(@TransferEntryID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
Update dbo.TransferEntry
SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE   TransferEntryID=@TransferEntryID
GO