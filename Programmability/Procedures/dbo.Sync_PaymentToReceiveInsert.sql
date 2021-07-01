SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_PaymentToReceiveInsert]
(
@PaymentToReceiveID uniqueidentifier,
@PaymentID uniqueidentifier,
@ReceiveID uniqueidentifier,
@Amount decimal(19,3),
@ModifierID uniqueidentifier)
as

if (SELECT COUNT(*)
FROM dbo.PayToBill
WHERE PayToBillID=@PaymentToReceiveID)>0 RETURN

Declare @BillID uniqueidentifier
set @BillID=(Select BillID
			 From dbo.ReceiveOrder 
			 Where ReceiveID=@ReceiveID)
 
Exec [SP_PayToBillInsert] @PaymentToReceiveID,@PaymentID,@BillID,@Amount,null,0,1,@ModifierID
GO