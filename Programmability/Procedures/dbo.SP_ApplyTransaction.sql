SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ApplyTransaction]
(@TransactionID uniqueidentifier,
@ModifierID uniqueidentifier)
as
		DECLARE @CustomerID uniqueidentifier
		SET @CustomerID=(select CustomerID from [transaction] where TransactionID=@TransactionID)

		if (select StartSaleTime from [transaction] where TransactionID=@TransactionID) >=dbo.GetCustomerDateStartBalance(@CustomerID)
		begin

			DECLARE @AmountToApply money
			DECLARE @DebitToPay money

			SET @AmountToApply=(select Credit from [transaction] where TransactionID=@TransactionID)
				if ((select Debit from [transaction] where TransactionID=@TransactionID)<0 )--for return transaction
					SET @AmountToApply=@AmountToApply-(select Debit from [transaction] where TransactionID=@TransactionID)
			
				IF (@AmountToApply>0)
					EXEC ApplyOldDebits @AmountToApply,@TransactionID,@CustomerID,@ModifierID
			
			
				SET @DebitToPay=(select LeftDebit from dbo.LeftDebitsView where TransactionID=@TransactionID)
				
				IF (@DebitToPay>0)
					EXEC PayDebitsFromOverPayments @DebitToPay,@TransactionID,@CustomerID,@ModifierID
		end
GO