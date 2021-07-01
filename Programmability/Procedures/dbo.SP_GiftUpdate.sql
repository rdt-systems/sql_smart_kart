SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftUpdate]
( @GiftID uniqueidentifier,
@GiftNumber nvarchar(50),
@CustomerID uniqueidentifier,
@Amount money,
@GiftType int,
@GiftDate datetime,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update dbo.Gift
SET
			GiftNumber=@GiftNumber, 
			CustomerID=@CustomerID, 
			Amount=@Amount, 
			GiftType= @GiftType,
			GiftDate=@GiftDate, 
			Status=@Status, 
			DateCreated=@UpdateTime, 
			UserCreated=@ModifierID, 
			DateModified=@UpdateTime, 
			UserModified=@ModifierID
where  (GiftID=@GiftID)
	and (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO