SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveEntryInsert]
           (@SalesIncentiveEntryID uniqueidentifier
           ,@TransactionEntryID uniqueidentifier
           ,@IncentivePercent decimal(18,0)
           ,@IncentiveAmount money
           ,@SalesValue decimal(18,0)
           ,@Posted bit
           ,@Status int
           ,@ModifierID uniqueidentifier)
AS 

declare @DateCreated datetime
SET @DateCreated=dbo.GetLocalDATE()

INSERT INTO [dbo].[SalesIncentiveEntry]
           ([SalesIncentiveEntryID]
           ,[TransactionEntryID]
           ,[IncentivePercent]
           ,[IncentiveAmount]
           ,[SalesValue]
           ,[Posted]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated])
     VALUES
           (@SalesIncentiveEntryID
           ,@TransactionEntryID
           ,@IncentivePercent
           ,@IncentiveAmount
           ,@SalesValue
           ,@Posted
           ,IsNull(@Status,1)
           ,@DateCreated
           ,@ModifierID)
GO