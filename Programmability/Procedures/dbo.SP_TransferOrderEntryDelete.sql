SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferOrderEntryDelete]
(@TransferOrderEntryID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
Update dbo.TransferOrderEntry
SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE   TransferOrderEntryID=@TransferOrderEntryID
GO