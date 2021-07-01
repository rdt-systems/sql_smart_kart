SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionVoid]
(@TransactionID uniqueidentifier,
@Reason nvarchar(4000),
 @ModifierID uniqueidentifier)

AS

Update dbo.[Transaction]
SET                  
                               
          Status = 0, 
		  VoidReason=@Reason,
          DateModified =  dbo.GetLocalDATE(),
          UserModified = @ModifierID,
          currBalance= null 
          
WHERE  TransactionID  = @TransactionID


-- Update currBalance after this Transaction
--update [Transaction]
--set currBalance=(SELECT round(SUM(Debit) - SUM(Credit), 2)
--		 FROM [Transaction] tr
--		 WHERE [Transaction].customerid = tr.customerid AND tr.startsaletime <= [Transaction].startsaletime and Status>0
--		 And StartSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID))
--Where CustomerID=(select CustomerID from [Transaction] where TransactionID=@TransactionID)
--      and startsaletime>=(select startsaletime from [Transaction] where TransactionID=@TransactionID)


EXEC	[dbo].[SP_UpdateRuningBalance] @TransactionID = @TransactionID
--if (SELECT TransactionType From [Transaction] Where TransactionID=@TransactionID)=2
--begin
--Update customer
--	SET StartBalance=isnull(
--						(Select Debit-Credit from [transaction] where customerid=customer.customerid 
--							and status>0 and EndSaleTime=Dbo.GetCustomerDateStartBalance(CustomerID))
--							,0),
--	StartBalanceDate=Dbo.GetCustomerDateStartBalance(CustomerID)
--	Where CustomerID=(select CustomerID from [Transaction] where TransactionID=@TransactionID)
--end

-----------Update Customer Balance subtract the old balance
declare @CustomerID uniqueidentifier
Set @CustomerID=(Select CustomerID From [transaction] Where TransactionID=@TransactionID)
if @CustomerID is not null
	EXEC CustomerBalanceUpdate @CustomerID
/*
DECLARE @OldTransactionBalance Money -- Old Balance
Set @OldTransactionBalance = (Select Debit - Credit  From dbo.[Transaction]  where TransactionID = @TransactionID)

if (select transactionType from [transaction] where transactionID=@TransactionID)=0--Sale --Update the aging
   begin

	declare @Diff as int
	set @Diff=datediff(day,(select DueDate from [transaction] WHERE TransactionID=@TransactionID),dbo.GetLocalDATE())
	
	UPDATE  dbo.Customer
	  SET 
	
		BalanceDoe = ( isnull(BalanceDoe,0)  - isnull(@OldTransactionBalance,0)),  
		[current] = isnull([current],0) -
			case when @diff<0 then isnull(@OldTransactionBalance,0) else 0 end,
		Over0 = isnull(Over0,0) -
			case when @diff>=0 and @diff<30 then isnull(@OldTransactionBalance,0) else 0 end,
		Over30 = isnull(Over30,0) -
			case when @diff>=30 and @diff<60 then isnull(@OldTransactionBalance,0) else 0 end,
		Over60 = isnull(Over60,0) -
			case when @diff>=60 and @diff<90 then isnull(@OldTransactionBalance,0) else 0 end,	
		Over90 = isnull(Over90,0) -
			case when @diff>=90 and @diff<120 then isnull(@OldTransactionBalance,0) else 0 end,	
		Over120 = isnull(Over120,0) -
			case when @diff>=120 then isnull(@OldTransactionBalance,0) else 0 end,
		DateModified=dbo.GetLocalDATE(), 
		UserModified= @ModifierID 
	
	  WHERE CustomerID =(select CustomerID from [transaction] where TransactionID = @TransactionID)
   end
else
   begin

	UPDATE  dbo.Customer
	  SET 
	
		BalanceDoe = ( isnull(BalanceDoe,0)  - isnull(@OldTransactionBalance,0)),  
		DateModified=dbo.GetLocalDATE(), 
		UserModified= @ModifierID 
	
	  WHERE CustomerID =(select CustomerID from [transaction] where TransactionID = @TransactionID)
   end
 */    

--************************************

------------------Delete Entries

if (select transactionType from [transaction] where transactionID=@TransactionID)=0 or (select transactionType from [transaction] where transactionID=@TransactionID)=3 --Sale Or return
	begin
	
	DECLARE @TransEntryID uniqueidentifier
	
	DECLARE DelEntries CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT TransactionEntryID
	FROM dbo.TransactionEntry WHERE(TransactionID=@TransactionID) 
	
	OPEN DelEntries
	
	FETCH NEXT FROM DelEntries 
	INTO @TransEntryID   -- holds the current transaction entry
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			if (SELECT status from transactionEntry where TransactionEntryID=@TransEntryID)=1
				exec SP_TransactionEntryVoid @TransEntryID,@ModifierID
		FETCH NEXT FROM DelEntries    --insert the next values to the instance
			INTO @TransEntryID
		END
	
	CLOSE DelEntries
	DEALLOCATE DelEntries
	
	end 
	
	UPDATE TenderEntry  SET Status = 0 where TransactionID = @TransactionID 


    UPDATE dbo.Loyalty SET Status = 0 WHERE  TRANSACTIONID=@TransactionID


	--Update all coupons which related to this transaction
update CouponUsed SET Status =-1,Datemodified=dbo.GetLocalDATE() where TransactionID=@TransactionID
Declare @CouponID uniqueidentifier = NULL
If (Select COUNT(*) from Coupon Where TransactionID = @TransactionID) >0
Select @CouponID = CouponID from Coupon Where TransactionID = @TransactionID

IF @CouponID IS NOT NULL
Begin
Exec SP_ZeroGift @GiftID = @CouponID
Update Coupon Set Status = -1, DateModified = dbo.GetLocalDATE() where CouponID = @CouponID
End
Update Coupon Set Amount=AmountAdd-AmountUsed,Datemodified =dbo.GetLocalDATE()
FROM            Coupon INNER JOIN
                             (SELECT        SUM(IsNull(Amount, 0)) AS AmountUsed, CouponID, SUM(IsNull(AmountAdd, 0)) AS AmountAdd
                               FROM            CouponUsed
                               WHERE        (Status > 0)
                               GROUP BY CouponID ) CouponHistory ON Coupon.CouponID = CouponHistory.CouponID
							   where Coupon.CouponID in(Select CouponID from CouponUsed where TransactionID=@TransactionID)

--	begin
	
	
--	DECLARE @PaymentID uniqueidentifier
	
--if (select transactionType from [transaction] where transactionID=@TransactionID)=1 or  (select transactionType from [transaction] where transactionID=@TransactionID)=3 --Payment or return
--	DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
--	SELECT PaymentID
--	FROM dbo.PaymentDetails WHERE(TransactionID=@TransactionID) 
--ELSE
--	DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
--	SELECT PaymentID
--	FROM dbo.PaymentDetails WHERE(TransactionPayedID=@TransactionID or TransactionID=@TransactionID)  
--END
--	OPEN c2
	
--	FETCH NEXT FROM c2 
--	INTO @PaymentID   -- holds the current transaction entry
	
--	WHILE @@FETCH_STATUS = 0
--		BEGIN
--			if (SELECT status from PaymentDetails where PaymentID=@PaymentID)=1
--				exec SP_PaymentDetailsVoid @PaymentID,@ModifierID
--		FETCH NEXT FROM c2    --insert the next values to the instance
--			INTO @PaymentID
--		END
	
--	CLOSE c2
--	DEALLOCATE c2
------------------------------------------------
GO