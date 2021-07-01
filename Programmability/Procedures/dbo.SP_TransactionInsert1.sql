SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_TransactionInsert1]
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
@TaxRate decimal(19,3) =NULL,
@Rounding money =NULL,
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
@RecieptTxt ntext,
@RegisterID UniqueIdentifier,
@ResellerID uniqueIdentifier=NULL,
@RegShiftID uniqueIdentifier=NULL,
@VoidReason nvarchar(50)= NULL,
@SaleAssociateID uniqueidentifier = Null )
--,
--@ConnectionString nvarchar(100))

AS 

Declare @D dateTime

if ((select Count(*) from [transaction] where TransactionID=@TransactionID and Status>-1)> 0) 
begin
	 return
end

If (dbo.getday(@StartSaleTime) > dbo.getday(dbo.GetLocalDATE()) +2) or (DATEPART(YEAR, @StartSaleTime) < DATEPART(YEAR, dbo.GetLocalDATE()) -10)
Set @D = dbo.GetLocalDATE()
  Else
Set @D = @StartSaleTime



SET XACT_ABORT ON;
BEGIN TRANSACTION
if ((select Count(*) from [transaction] where TransactionNo=@TransactionNo and Status>-1)> 0) 
begin
	 RAISERROR  ('Transaction No Alredy Exists.',20,1)  --WITH LOG

end


declare @CurrBalance money

IF (@CustomerID is not null AND @Status>0 ) 
  SET @CurrBalance = isnull((Select BalanceDoe from Customer Where customerid=@CustomerID),0)+isnull(@Debit,0) - isnull(@Credit,0)
ELSE
  SET @CurrBalance = 0


INSERT INTO dbo.[Transaction]
                      (TransactionID, TransactionNo, TransactionType, RegisterTransaction,BatchID, StoreID, CustomerID,  
			Debit, Credit, StartSaleTime,EndSaleTime, DueDate,LeftDebit,Freight, Tax, TaxID,  TaxType,TaxRate,Rounding , ShipTo, ShipVia,
			PONo, RepID ,TermsID ,PhoneOrder,ToPrint,ToEmail,CustomerMessage,
                      	Note,ResellerID, Status,VoidReason, DateCreated, UserCreated, DateModified, UserModified,CurrBalance,RecieptTxt,registerid,RegShiftID)

VALUES     		(@TransactionID, @TransactionNo, @TransactionType,@RegisterTransaction, @BatchID, @StoreID, @CustomerID,  
			isnull(round(@Debit,2),0), round(@Credit,2), @D,@EndSaleTime, @DueDate,case when @Debit<0 then @debit-@credit else @debit end,@Freight,@Tax,@TaxID,@TaxType,@TaxRate,@Rounding,  @ShipTo, @ShipVia,
			@PONo, @RepID ,@TermsID ,@PhoneOrder,@ToPrint,@ToEmail,@CustomerMessage,
			@Note, @ResellerID, @Status,@VoidReason, dbo.GetLocalDATE(), @ModifierID, null, null,@CurrBalance,@RecieptTxt,@registerid,@RegShiftID)


declare @Paid money
declare @PaidDate datetime 



IF (@CustomerID is not null) AND @Status>0 
BEGIN
	if (@Credit - @Debit) >0 begin
	  SET @Paid =(@Credit - @Debit)
	  SET @PaidDate =dbo.GetLocalDATE()
	END
	ELSE BEGIN
	  SET @Paid =null
	  SET @PaidDate =null
	END
	UPDATE Customer set BalanceDoe= (IsNull(BalanceDoe,0)+@Debit-@Credit),DateModified =dbo.GetLocalDATE(), LastSaleDate = @EndSaleTime, LastPayment =ISNULL(@Paid,LastPayment),LastPaymentDate=ISNULL(@PaidDate,LastPaymentDate) WHERE CustomerID = @CustomerID
END

if @SaleAssociateID is not null 
BEGIN
  PRINT 'YES'
  EXEC SP_SaleAssociateInsert @TransactionID =@transactionID,@SaleAssociateID=@SaleAssociateID
END

COMMIT TRANSACTION;

--exec dbo.ApplyTransacion @TransactionID,@ConnectionStringdatasoft	dsdsds

--	IF (@CustomerID is  null) 
--	BEGIN
--		DECLARE  @PDID UNIQUEIDENTIFIER
--		set @PDID= newid()
--		DECLARE  @AbsCredit money
--		set @AbsCredit= abs(@Credit)
--		exec SP_PaymentDetailsInsert	 @PDID,@TransactionID,@TransactionID,@AbsCredit,null,1,@ModifierID
--	END
GO