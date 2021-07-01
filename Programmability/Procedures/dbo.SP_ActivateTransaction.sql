SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =============================================
-- Author:		Moshe Freund
-- Create date: 12/19/2016
-- Description:	Unvoid Transaction
-- =============================================
CREATE PROCEDURE [dbo].[SP_ActivateTransaction] (
	@TransactionID uniqueidentifier,
	@CustomerID uniqueidentifier = NULL,
	@Status int = 0
	)
AS

Update [Transaction] Set Status = 1, DateModified = dbo.GetLocalDate() where TransactionID = @TransactionID AND Status = @Status

Update TransactionEntry Set Status = 1, DateModified = dbo.GetLocalDate() where TransactionID = @TransactionID AND Status = @Status

Update TenderEntry Set Status = 1, DateModified = dbo.GetLocalDate() where TransactionID = @TransactionID AND Status = @Status

IF @CustomerID IS NOT NULL
EXEC CustomerBalanceUpdate @CustomerID

Exec SP_UpdateAfterTransactionInsert @TransactionID = @TransactionID
GO