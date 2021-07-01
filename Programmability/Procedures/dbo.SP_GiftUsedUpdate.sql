SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftUsedUpdate]
(@GiftUsedID uniqueidentifier,
@GiftEntryNo uniqueidentifier,
@TransactionID uniqueidentifier,
@AmountUsed money,
@UsedDate datetime,
@Status smallint,
@DateModified datetime,
@ModifierId uniqueidentifier)
AS

--Declare @UpdateTime datetime
--set  @UpdateTime =dbo.GetLocalDATE()

-- UPDATE   dbo.GiftUsed
--SET              GiftEntryNo = @GiftEntryNo, AmountUsed = @AmountUsed, TransactionID = @TransactionID,UsedDate=@UsedDate , Status = 

--@Status, 
--                      UserCREATEd = @ModifierId, DateModified = @UpdateTime, UserModified = @ModifierId
--WHERE     (GiftUsedID = @GiftUsedID) AND 
--      (DateModified = @DateModified OR DateModified IS NULL)

--select @UpdateTime as DateModified
GO