SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveEntryUpdate]
           (@SalesIncentiveEntryID uniqueidentifier
           ,@TransactionEntryID uniqueidentifier
           ,@IncentivePercent decimal(18,0)
           ,@IncentiveAmount money
           ,@SalesValue decimal(18,0)
           ,@Posted bit
           ,@Status int
		   ,@DateModified datetime
           ,@ModifierID uniqueidentifier)
AS 
declare @vDateModified datetime
SET @vDateModified=dbo.GetLocalDATE()

UPDATE [dbo].[SalesIncentiveEntry]
   SET [TransactionEntryID] = @TransactionEntryID
      ,[IncentivePercent] = @IncentivePercent
      ,[IncentiveAmount] = @IncentiveAmount
      ,[SalesValue] = @SalesValue
      ,[Posted] = @Posted
      ,[Status] = @Status
      ,[DateModified] = @vDateModified
      ,[UserModified] = @ModifierID
 WHERE [SalesIncentiveEntryID] = @SalesIncentiveEntryID
GO