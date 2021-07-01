SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ApplyAllTransaction]
(@ModifierID uniqueidentifier)
as

DECLARE @TransactionID uniqueidentifier
DECLARE @CustomerID uniqueidentifier
DECLARE @AmountToApply money
DECLARE @DebitToPay money

DECLARE cApply CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT TransactionID,CustomerID,credit-isnull(AppliedAmount,0) -- all Transaction that belong to the current customer and have balance that did not paid
FROM transactionWithPaidview WHERE Status>0 and isnull(AppliedAmount,0)<(credit - case when debit < 0 then debit else 0 end) and (credit - case when debit < 0 then debit else 0 end)>0

OPEN cApply

FETCH NEXT FROM cApply 
INTO @TransactionID,@CustomerID,@AmountToApply -- holds the current transaction and the left debit

WHILE @@FETCH_STATUS = 0
	BEGIN
		if (select EndSaleTime from [transaction] where TransactionID=@TransactionID) >=
			IsNull((select Max(EndSaleTime) From [Transaction] 
			Where Status>0 and customerID=@CustomerID and transactionType=2),'1753/1/1')
		begin

				if ((select Debit from [transaction] where TransactionID=@TransactionID)<0 )--for return transaction
					SET @AmountToApply=@AmountToApply-(select Debit from [transaction] where TransactionID=@TransactionID)
			
				IF (@AmountToApply>0)
					EXEC ApplyOldDebits @AmountToApply,@TransactionID,@CustomerID,@ModifierID
			
			
				SET @DebitToPay=(select LeftDebit from dbo.LeftDebitsView where TransactionID=@TransactionID)
				
				IF (@DebitToPay>0)
					EXEC PayDebitsFromOverPayments @DebitToPay,@TransactionID,@CustomerID,@ModifierID
		end



		FETCH NEXT FROM cApply 
		INTO @TransactionID,@CustomerID,@AmountToApply
	END

CLOSE cApply
DEALLOCATE cApply
GO