SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionBatchDelete]
(@BatchId uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
UPDATE  dbo.Batch
SET 
  Status = -1,
  DateModified = dbo.GetLocalDATE(), 
  UserModified = @ModifierID

WHERE  BatchId =@BatchId
GO