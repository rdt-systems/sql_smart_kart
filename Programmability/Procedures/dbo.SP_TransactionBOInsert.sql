SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionBOInsert]
(
@TransactionID uniqueidentifier,
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
@TaxRate Decimal(19,4),
@Rounding money,
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
@DeliveryDate DateTime,
@TrackNo nvarchar(50),
@Status smallint,
@ModifierID uniqueidentifier,
@ResellerID uniqueIdentifier = null)

AS 
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @Date datetime
set  @Date =dbo.GetLocalDATE()

declare @CurrBalance money
set @CurrBalance = isnull((Select BalanceDoe from Customer Where customerid=@CustomerID),0)+isnull(@Debit,0) - isnull(@Credit,0)

INSERT INTO dbo.[Transaction]
            (TransactionID, TransactionNo, TransactionType, RegisterTransaction,BatchID, StoreID, CustomerID,  
			Debit, Credit, StartSaleTime,EndSaleTime, DueDate,LeftDebit,Freight, Tax, TaxID,  TaxType,TaxRate,
			Rounding, ShipTo, ShipVia,PONo, RepID ,TermsID ,PhoneOrder,ToPrint,ToEmail,CustomerMessage,
                      	Note, ResellerID,DeliveryDate, TrackNo, Status, DateCreated, UserCreated, DateModified, UserModified,CurrBalance)

VALUES     	(@TransactionID, @TransactionNo, @TransactionType,@RegisterTransaction, @BatchID, @StoreID, @CustomerID,  
			@Debit, @Credit, @StartSaleTime,@EndSaleTime, @DueDate,@Debit ,@Freight,@Tax,@TaxID,@TaxType,@TaxRate,  
			@Rounding, @ShipTo, @ShipVia,@PONo, @RepID ,@TermsID ,@PhoneOrder,@ToPrint,@ToEmail,@CustomerMessage,
			@Note, @ResellerID,@DeliveryDate, @TrackNo, isnull(@Status,1), @Date, @ModifierID, @Date, @ModifierID,@currBalance)

--INSERT INTO dbo.W_Transaction
--            (TransactionID, TransactionNo, TransactionType, RegisterTransaction,BatchID, StoreID, CustomerID,  
--			Debit, Credit, StartSaleTime,EndSaleTime, DueDate,LeftDebit,Freight, Tax, TaxID,  TaxType,TaxRate,
--			Rounding, ShipTo, ShipVia,PONo, RepID ,TermsID ,PhoneOrder,ToPrint,ToEmail,CustomerMessage,
--                      	Note, ResellerID,DeliveryDate, TrackNo, Status, DateCreated, UserCreated, DateModified, UserModified,CurrBalance)
--
--VALUES     	(@TransactionID, @TransactionNo, @TransactionType,@RegisterTransaction, @BatchID, @StoreID, @CustomerID,  
--			@Debit, @Credit, @StartSaleTime,@EndSaleTime, @DueDate,(@Debit-@Credit) ,@Freight,@Tax,@TaxID,@TaxType,@TaxRate,  
--			@Rounding, @ShipTo, @ShipVia,@PONo, @RepID ,@TermsID ,@PhoneOrder,@ToPrint,@ToEmail,@CustomerMessage,
--			@Note, @ResellerID,@DeliveryDate, @TrackNo, isnull(@Status,1), @Date, @ModifierID, @Date, @ModifierID,@currBalance)

-- Update currBalance after this Transaction

IF (@TransactionType=1) AND (@CustomerID is not NULL) 
BEGIN
  UPDATE Customer SET LastPayment =@Credit,LastPaymentDate =@StartSaleTime WHERE CustomerID = @CustomerID
END

IF (@CustomerID is not null) AND @Status>0 
BEGIN
 UPDATE Customer set BalanceDoe= (IsNull(BalanceDoe,0)+@Debit-@Credit),DateModified =dbo.GetLocalDATE() WHERE CustomerID = @CustomerID
END

EXEC [dbo].[SP_UpdateRuningBalance] @TransactionID = @TransactionID

--exec UpdateToTransaction @startsaletime,@CustomerID

select @UpdateTime as DateModified
GO