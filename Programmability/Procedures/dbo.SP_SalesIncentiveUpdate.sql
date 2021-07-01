SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveUpdate]
           (@SalesIncentiveID uniqueidentifier
           ,@ItemMainID uniqueidentifier
		   ,@SalesIncentiveHeaderID uniqueidentifier
           ,@IncentiveValuePercent decimal(18,3)
           ,@IncentiveValueAmount money
           ,@FromDate datetime
           ,@ToDate datetime
           ,@Status int
           ,@ModifierID uniqueidentifier
		   ,@DateModified datetime
)
AS 
declare @vDateModified datetime
SET @vDateModified=dbo.GetLocalDATE()

UPDATE [dbo].[SalesIncentive]
   SET [ItemMainID] = @ItemMainID
      ,[SalesIncentiveHeaderID]= @SalesIncentiveHeaderID 
      ,[IncentiveValuePercent] = @IncentiveValuePercent
      ,[IncentiveValueAmount] = @IncentiveValueAmount
      ,[FromDate] = @FromDate
      ,[ToDate] = @ToDate
      ,[Status] = IsNull(@Status,1)
      ,[DateModified] = @vDateModified
      ,[UserModified] = @ModifierID 
 WHERE  [SalesIncentiveID] = @SalesIncentiveID
GO