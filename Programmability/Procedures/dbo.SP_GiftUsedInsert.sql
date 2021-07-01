SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftUsedInsert]
(@GiftUsedID uniqueidentifier,
@GiftEntryNo uniqueidentifier,
@TransactionID uniqueidentifier,
@AmountUsed money,
@UsedDate datetime,
@Status smallint,
@ModifierId uniqueidentifier)
AS 
--INSERT INTO dbo.GiftUsed
--                      (GiftUsedID, GiftEntryNo, TransactionID, AmountUsed,UsedDate, Status,DateCREATE, UserCREATE, DateModified, UserModified)
--VALUES     (@GiftUsedID, @GiftEntryNo, @TransactionID, @AmountUsed,@UsedDate,1,dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO