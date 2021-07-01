SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveHeaderUpdate]
           (@SalesIncentiveHeaderID uniqueidentifier
           ,@Name nvarchar(50)
           ,@FromDate datetime
           ,@ToDate datetime
           ,@IncentiveAmount money
           ,@IncentivePercent decimal(18,2)
           ,@Status int
           ,@ModifierID uniqueidentifier
		   ,@DateModified datetime)
AS

UPDATE [dbo].[SalesIncentiveHeader]
   SET [Name] = @Name
      ,[FromDate] = @FromDate
      ,[ToDate] = @ToDate
      ,[IncentiveAmount] = @IncentiveAmount
      ,[IncentivePercent] = @IncentivePercent
      ,[Status] = IsNull(@Status,1)
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID
 WHERE  [SalesIncentiveHeaderID] = @SalesIncentiveHeaderID
GO