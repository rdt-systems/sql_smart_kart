SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionInsert]
(@TransactionID uniqueidentifier,
@TransactionNo nvarchar(50),
@TransactionType int,
@RegisterTransaction bit,
@BatchID uniqueidentifier,
@StoreID uniqueidentifier,
@CustomerID uniqueidentifier,
@Debit money,
@Credit money,
@StartSaleTime datetime,
@EndSaleTime datetime,
@DueDate datetime,
@Freight money,
@Tax money,
@TaxID uniqueidentifier,
@TaxType nvarchar(50),
@TaxRate decimal(19,3),
@ShipTo uniqueidentifier,
@ShipVia uniqueidentifier,
@PONo nvarchar(50),
@RepID uniqueidentifier,
@TermsID uniqueidentifier,
@PhoneOrder bit,
@ToPrint bit,
@ToEmail bit,
@CustomerMessage uniqueidentifier,
@Note nvarchar(4000),
@Status smallint,
@ModifierID uniqueidentifier,
@RecieptTxt text,
@RegisterID UniqueIdentifier,
@ResellerID uniqueIdentifier=null)



AS 


Declare @D dateTime
If (dbo.getday(@StartSaleTime) > dbo.getday(dbo.GetLocalDATE()) +2) or (DATEPART(YEAR, @StartSaleTime) < DATEPART(YEAR, dbo.GetLocalDATE()) -10)
Set @D = dbo.GetLocalDATE()
Else
Set @D = @StartSaleTime

if ((select Count(*) from [transaction] where TransactionNo=@TransactionNo and Status>-1)> 0) 
begin
	 RAISERROR  ('Transaction No Alredy Exists.',20,1)  --WITH LOG

end
declare @CurrBalance money
set @CurrBalance = isnull((Select BalanceDoe from Customer Where customerid=@CustomerID),0)+isnull(@Debit,0) - isnull(@Credit,0)

INSERT INTO dbo.[Transaction]
                      (TransactionID, TransactionNo, TransactionType, RegisterTransaction,BatchID, StoreID, CustomerID,  
			Debit, Credit, StartSaleTime,EndSaleTime, DueDate,LeftDebit,Freight, Tax, TaxID,  TaxType,TaxRate, ShipTo, ShipVia,
			PONo, RepID ,TermsID ,PhoneOrder,ToPrint,ToEmail,CustomerMessage,
                      	Note,ResellerID, Status, DateCreated, UserCreated, DateModified, UserModified,CurrBalance,RecieptTxt,registerid)

VALUES     		(@TransactionID, @TransactionNo, @TransactionType,@RegisterTransaction, @BatchID, @StoreID, @CustomerID,  
			isnull(round(@Debit,2),0), round(@Credit,2), @D,@D, @DueDate,@Debit,
--case when @Debit<0 then @debit-@credit else @debit end,
@Freight,@Tax,@TaxID,@TaxType,@TaxRate,  @ShipTo, @ShipVia,
			@PONo, @RepID ,@TermsID ,@PhoneOrder,@ToPrint,@ToEmail,@CustomerMessage,
			@Note, @ResellerID, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@CurrBalance,@RecieptTxt,@registerid)

-- Update currBalance after this Transaction
update [Transaction]
set currBalance=(SELECT round(SUM(Debit) - SUM(Credit), 2)
		 FROM [Transaction] tr
		 WHERE [Transaction].customerid = tr.customerid AND tr.startsaletime <= [Transaction].startsaletime and Status>0
		 And StartSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID))
Where CustomerID=@CustomerID and startsaletime>=@startsaletime

IF (@TransactionType=1) AND (@CustomerID is not NULL) 
BEGIN
  UPDATE Customer SET LastPayment =@Credit,  LastSaleDate = @EndSaleTime,LastPaymentDate =@StartSaleTime WHERE CustomerID = @CustomerID
END

DECLARE @AmountToApply money
DECLARE @DebitToPay money

DECLARE @ApplySettings smallint

--Temp: Which Settings To Use:
SET @ApplySettings=2

IF (@ApplySettings=1)

--Pay Current Transaction Settings***********************************************************
	BEGIN
	IF (@Credit>0) and (@Debit>0)
	BEGIN
		DECLARE @CurrTransSum money
		IF (@Debit>@Credit)
		BEGIN
			SET @CurrTransSum=@Credit
			SET @DebitToPay=@Debit-@Credit
		END
		ELSE
		BEGIN
			SET @CurrTransSum=@Debit
			SET @AmountToApply=@Credit-@Debit
		END
	
		INSERT INTO dbo.PaymentDetails(PaymentID,TransactionID,TransactionPayedID,Amount,Note,Status,DateCreated,UserCreated,DateModified,UserModified)
					values(NEWID(),@TransactionID,@TransactionID,@CurrTransSum,null,1,dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
	END
	ELSE
	BEGIN
		IF (@Debit>0)
			SET @DebitToPay=@Debit
		ELSE IF (@Credit>0)
			SET @AmountToApply=@Credit
		ELSE IF (@Debit<0) and (@Credit=0)	--Return to customer account
			SET @AmountToApply=@Debit * (-1)
		ELSE IF (@Debit<0) and (@Debit=@Credit)	--Return With Cash Credit
			INSERT INTO dbo.PaymentDetails(PaymentID,TransactionID,TransactionPayedID,Amount,Note,Status,DateCreated,UserCreated,DateModified,UserModified)
						values(NEWID(),@TransactionID,@TransactionID,@Debit * (-1),null,1,dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
		
	END	
	
	IF (@AmountToApply>0)
		EXEC ApplyOldDebits @AmountToApply,@TransactionID,@CustomerID,@ModifierID
	IF (@DebitToPay>0)
		EXEC PayDebitsFromOverPayments @DebitToPay,@TransactionID,@CustomerID,@ModifierID
	END
--*******************************************************************************************     

ELSE
                                                                                                                                  
--Pay Old Debits Settings********************************************************************
	BEGIN
	IF (@CustomerID is null) --If There Is No Customer - Credit And Debit Must Be Equal, And There Is No Old Debit.
	BEGIN
		DECLARE  @PDID UNIQUEIDENTIFIER
		set @PDID= newid()
		DECLARE  @AbsCredit money
		set @AbsCredit= abs(@Credit)
		exec SP_PaymentDetailsInsert	 @PDID,@TransactionID,@TransactionID,@AbsCredit,null,1,@ModifierID
	END
	ELSE
	BEGIN
		if @StartSaleTime>=dbo.GetCustomerDateStartBalance(@CustomerID)
		begin
			SET @AmountToApply=@Credit
				if (@Debit<0 )--for return transaction
					SET @AmountToApply=@Credit-@Debit 
			
--				IF (@AmountToApply>0)
--					EXEC ApplyOldDebits @AmountToApply,@TransactionID,@CustomerID,@ModifierID
--			
--			
--				SET @DebitToPay=(select LeftDebit from dbo.LeftDebitsView where TransactionID=@TransactionID)
--				
--				IF (@DebitToPay>0)
--					EXEC PayDebitsFromOverPayments @DebitToPay,@TransactionID,@CustomerID,@ModifierID
		end
	END
	END
--*******************************************************************************************  

--Update Customer Balance
if @CustomerID is not null
	EXEC CustomerBalanceUpdate @CustomerID


--if ((select Count(*) from W_transaction where TransactionNo=@TransactionNo and Status>-1)> 0) 
--begin
--	 RAISERROR  ('Transaction No Alredy Exists.',20,1)  WITH LOG
--
--end

--INSERT INTO dbo.[W_Transaction]
--                      (TransactionID, TransactionNo, TransactionType, RegisterTransaction,BatchID, StoreID, CustomerID,  
--			Debit, Credit, StartSaleTime,EndSaleTime, DueDate,LeftDebit,Freight, Tax, TaxID,  TaxType,TaxRate, ShipTo, ShipVia,
--			PONo, RepID ,TermsID ,PhoneOrder,ToPrint,ToEmail,CustomerMessage,
--                      	Note,ResellerID, Status, DateCreated, UserCreated, DateModified, UserModified,CurrBalance,RecieptTxt,registerid)
--
--VALUES     		(@TransactionID, @TransactionNo, @TransactionType,@RegisterTransaction, @BatchID, @StoreID, @CustomerID,  
--			isnull(round(@Debit,2),0), round(@Credit,2), @EndSaleTime,@EndSaleTime, @DueDate,case when @Debit<0 then @debit-@credit else @debit end,@Freight,@Tax,@TaxID,@TaxType,@TaxRate,  @ShipTo, @ShipVia,
--			@PONo, @RepID ,@TermsID ,@PhoneOrder,@ToPrint,@ToEmail,@CustomerMessage,
--			@Note, @ResellerID, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@CurrBalance,@RecieptTxt,@registerid)

-- Update currBalance after this Transaction
--update W_Transaction
--set currBalance=(SELECT round(SUM(Debit) - SUM(Credit), 2)
--		 FROM W_Transaction Wtr
--		 WHERE W_Transaction.customerid = Wtr.customerid AND Wtr.startsaletime <= W_Transaction.startsaletime and Status>0
--		 And StartSaleTime>=dbo.GetCustomerDateStartBalance(W_Transaction.CustomerID))
--Where CustomerID=@CustomerID and startsaletime>=@startsaletime
GO