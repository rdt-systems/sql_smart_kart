SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftEntryUpdate]
(@GiftEntryID uniqueidentifier,
@GiftTypeID uniqueidentifier,
@ActivDate datetime,
@ExpirationDate datetime,
@Amount money,
@Price money,
@GiftNo nvarchar (50),
@TransactionID uniqueidentifier,
@TransactionEntryID uniqueidentifier,
@status Smallint,
@DateModified datetime,
@ModifierId uniqueidentifier)

AS 

--Declare @UpdateTime datetime
--set  @UpdateTime =dbo.GetLocalDATE()

--UPDATE    dbo.GiftEntry
--SET              GiftTypeID = @GiftTypeID, ActivDate = @ActivDate, ExpirationDate = @ExpirationDate, Amount = @Amount, Price=@Price, 

--GiftNo = @GiftNo, 
--                      TransactionID = @TransactionID, TransactionEntryID = @TransactionEntryID, Status = @Status, UserCREATEd = @modifierId, 
--                      DateModified =@UpdateTime, UserModified = @modifierId

--WHERE     (GiftEntryID = @GiftEntryID) AND 
--      (DateModified = @DateModified OR DateModified IS NULL)



--select @UpdateTime as DateModified
GO