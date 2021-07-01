SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesIncentiveHeaderInsert]
           (@SalesIncentiveHeaderID uniqueidentifier
           ,@Name nvarchar(50)
           ,@FromDate datetime
           ,@ToDate datetime
           ,@IncentiveAmount money
           ,@IncentivePercent decimal(18,2)
           ,@Status int =1
           ,@ModifierID uniqueidentifier=null)
AS 

declare @DateCreated datetime
SET @DateCreated=dbo.GetLocalDATE()

INSERT INTO [dbo].[SalesIncentiveHeader]
           ([SalesIncentiveHeaderID]
           ,[Name]
           ,[FromDate]
           ,[ToDate]
           ,[IncentiveAmount]
           ,[IncentivePercent]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated])
     VALUES
           (@SalesIncentiveHeaderID
           ,@Name
           ,@FromDate
           ,@ToDate
           ,@IncentiveAmount
           ,@IncentivePercent
           ,IsNull(@Status,1)
           ,@DateCreated
           ,@ModifierID)
GO