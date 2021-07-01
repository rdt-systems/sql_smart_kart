SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CRMCallsInsert]
           (@CRMCallID uniqueidentifier,
           @CustomerID uniqueidentifier,
           @CallDate datetime,
           @Note varchar(1000),
           @Status	smallint,	
           @ModifierID	uniqueidentifier)

AS 
INSERT INTO [dbo].[CRMCalls]
           ([CRMCallID]
           ,[CustomerID]
           ,[CallDate]
           ,[Note]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           ,[UserModified])
     VALUES
           (@CRMCallID
           ,@CustomerID
           ,@CallDate
           ,@Note
		   ,1
		   ,dbo.GetLocalDATE()
		   ,@ModifierID
		   ,dbo.GetLocalDATE()
		   ,@ModifierID)
GO