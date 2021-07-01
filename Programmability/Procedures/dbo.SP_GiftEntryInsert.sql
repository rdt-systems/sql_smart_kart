SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftEntryInsert]
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
@ModifierId uniqueidentifier)
AS 
--INSERT INTO dbo.GiftEntry
--                      (GiftEntryID, GiftTypeID, ActivDate, ExpirationDate, Amount, Price,  GiftNo, TransactionID, TransactionEntryID, Status, DateCREATE, UserCREATE, DateModified,
--                       UserModified)
--VALUES     (@GiftEntryID, @GiftTypeID, @ActivDate, @ExpirationDate, @Amount, @Price, @GiftNo, @TransactionID, @TransactionEntryID, 1, dbo.GetLocalDATE(), @ModifierId, 
--                      dbo.GetLocalDATE(), @ModifierId)
GO