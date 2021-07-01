SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TransactionDelete]
(@TransactionID uniqueidentifier,
 @ModifierID uniqueidentifier)

AS

Declare @Sta int
Set @Sta=(select status from dbo.[Transaction] WHERE  TransactionID  = @TransactionID)

Update dbo.[Transaction]
SET                  
                               
          Status = -1, 
          DateModified =  dbo.GetLocalDATE(),
          UserModified = @ModifierID


WHERE  TransactionID  = @TransactionID

Update dbo.W_Transaction
SET                  
                               
          Status = -1, 
          DateModified =  dbo.GetLocalDATE(),
          UserModified = @ModifierID


WHERE  TransactionID  = @TransactionID

-- Update currBalance after this Transaction
update [Transaction]
set currBalance=(SELECT round(SUM(Debit) - SUM(Credit), 2)
		 FROM [Transaction] tr
		 WHERE [Transaction].customerid = tr.customerid AND tr.startsaletime <= [Transaction].startsaletime and Status>0
		 And StartSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID) )
Where CustomerID=(select CustomerID from [Transaction] where TransactionID=@TransactionID)
      and startsaletime>=(select startsaletime from [Transaction] where TransactionID=@TransactionID)


Update W_Transaction
set currBalance=(SELECT round(SUM(Debit) - SUM(Credit), 2)
		 FROM [Transaction] Wtr
		 WHERE W_Transaction.customerid = Wtr.customerid AND Wtr.startsaletime <= W_Transaction.startsaletime and Status>0
		 And StartSaleTime>=dbo.GetCustomerDateStartBalance(W_Transaction.CustomerID) )
Where CustomerID=(select CustomerID from W_Transaction where TransactionID=@TransactionID)
      and startsaletime>=(select startsaletime from W_Transaction where TransactionID=@TransactionID)


if (SELECT TransactionType From [Transaction] Where TransactionID=@TransactionID)=2
begin
Update customer
	SET StartBalance=isnull(
						(Select Debit-Credit from [transaction] where customerid=customer.customerid 
							and status>0 and EndSaleTime=Dbo.GetCustomerDateStartBalance(CustomerID))
							,0),
	StartBalanceDate=Dbo.GetCustomerDateStartBalance(CustomerID)
	Where CustomerID=(select CustomerID from [Transaction] where TransactionID=@TransactionID)
end


if @sta=1
begin
	
	-----------Update Customer Balance add the new balance and subtract the old balance
declare @CustomerID uniqueidentifier
Set @CustomerID=(Select CustomerID From [transaction] Where TransactionID=@TransactionID)
if @CustomerID is not null
	EXEC CustomerBalanceUpdate @CustomerID

end
--************************************

------------------Delete Entries

if (select transactionType from [transaction] where transactionID=@TransactionID)=0 or  (select transactionType from [transaction] where transactionID=@TransactionID)=3 --Sale Or return
	begin
	
	DECLARE @TransEntryID uniqueidentifier
	
	DECLARE DelEntry CURSOR LOCAL FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT TransactionEntryID
	FROM dbo.TransactionEntry WHERE(TransactionID=@TransactionID) 
	
	OPEN DelEntry
	
	FETCH NEXT FROM DelEntry 
	INTO @TransEntryID   -- holds the current transaction entry
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			exec SP_TransactionEntryDelete @TransEntryID,@ModifierID
		FETCH NEXT FROM DelEntry    --insert the next values to the instance
			INTO @TransEntryID
		END
	
	CLOSE DelEntry
	DEALLOCATE DelEntry
	
	end 

--Delete tender entry
	DECLARE @TenderEntryID uniqueidentifier
	
	DECLARE DelTenderEntry CURSOR LOCAL FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT TenderEntryID
	FROM dbo.TenderEntry WHERE(TransactionID=@TransactionID) 
	
	OPEN DelTenderEntry
	
	FETCH NEXT FROM DelTenderEntry 
	INTO @TenderEntryID   -- holds the current transaction entry
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			exec SP_TenderEntryDelete @TenderEntryID,@ModifierID
		FETCH NEXT FROM DelTenderEntry    --insert the next values to the instance
			INTO @TenderEntryID
		END
	
	CLOSE DelTenderEntry
	DEALLOCATE DelTenderEntry
	

begin
	DECLARE @PaymentID uniqueidentifier

	if (select transactionType from [transaction] where transactionID=@TransactionID)=1 or  (select transactionType from [transaction] where transactionID=@TransactionID)=3 --Payment or return

		DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT PaymentID
		FROM dbo.PaymentDetails WHERE(TransactionID=@TransactionID) 

	else 
		DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT PaymentID
		FROM dbo.PaymentDetails WHERE(TransactionPayedID=@TransactionID or TransactionID=@TransactionID) 
end
	
OPEN c2

FETCH NEXT FROM c2 
INTO @PaymentID   -- holds the current transaction entry

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec SP_PaymentDetailsDelete @PaymentID,@ModifierID
	FETCH NEXT FROM c2    --insert the next values to the instance
		INTO @PaymentID
	END
	
CLOSE c2
DEALLOCATE c2
----------------------------
GO