SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CRMCallsUpdate]
           (@CRMCallID uniqueidentifier,
            @CustomerID uniqueidentifier,
            @CallDate datetime,
            @Note varchar(1000),
			@Status	smallint,	
			@DateModified datetime,
			@ModifierID	uniqueidentifier	
)
AS
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE [dbo].[CRMCalls]
   SET [CustomerID] = @CustomerID
      ,[CallDate] = @CallDate
      ,[Note] = @Note
      ,[Status] = @Status
      ,[DateModified] = @UpdateTime
      ,[UserModified] = @ModifierID
 WHERE [CRMCallID] = @CRMCallID
GO