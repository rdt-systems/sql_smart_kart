SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UpdateWO]
(@SaleTransID uniqueidentifier,
@WOID uniqueidentifier,
@CustomerID uniqueidentifier,
@DepositAmount money,
@ModifierID uniqueidentifier)

AS



Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


/*
DECLARE @WOPaymentID uniqueidentifier
SET @WOPaymentID = (SELECT DepositTransactionID FROM WorkOrder WHERE WorkOrderID=@WOID)

--Applay Payments To TheCurrent Sale
IF (@DepositAmount>0)
BEGIN
	INSERT INTO dbo.PaymentDetails(PaymentID,TransactionID,TransactionPayedID,Amount,Note,Status,DateCREATE,UserCREATE,DateModified,UserModified)
				VALUES(NEWID(),@WOPaymentID,@SaleTransID,@DepositAmount,null,1,dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
END
DECLARE @LeftDebit money
SET @LeftDebit=(SELECT LeftDebit FROM dbo.LeftDebitsView WHERE TransactionID=@SaleTransID)
IF @LeftDebit>0
	EXEC PayDebitsFromOverPayments @LeftDebit,@SaleTransID,@CustomerID,@ModifierID
*/


select @UpdateTime as DateModified
GO