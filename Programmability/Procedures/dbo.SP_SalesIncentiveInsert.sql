SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveInsert]
           (@SalesIncentiveID uniqueidentifier
		   ,@SalesIncentiveHeaderID uniqueidentifier
           ,@ItemMainID uniqueidentifier
           ,@IncentiveValuePercent decimal(18,3)=null
           ,@IncentiveValueAmount money = null
           ,@FromDate datetime =null
           ,@ToDate datetime = null
           ,@Status int =1
           ,@ModifierID uniqueidentifier =null
)
AS 
declare @DateCreated datetime
SET @DateCreated=dbo.GetLocalDATE()

INSERT INTO [dbo].[SalesIncentive]
           ([SalesIncentiveID]
		   ,[SalesIncentiveHeaderID]
           ,[ItemMainID]
           ,[IncentiveValuePercent]
           ,[IncentiveValueAmount]
           ,[FromDate]
           ,[ToDate]
           ,[Status]
           ,[DateCreated]
           ,[DateModified]
           ,[UserCreated])
     VALUES
           (@SalesIncentiveID
		   ,@SalesIncentiveHeaderID
           ,@ItemMainID
           ,@IncentiveValuePercent
           ,@IncentiveValueAmount
           ,@FromDate
           ,@ToDate
           ,IsNull(@Status,1)
           ,@DateCreated
		   ,@DateCreated 
           ,@ModifierID)
GO