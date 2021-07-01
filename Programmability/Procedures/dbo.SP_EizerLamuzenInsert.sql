SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EizerLamuzenInsert]
(
@TransactionID uniqueidentifier,
@TransactionNo nvarchar(50),
@TransactionType int,
@RegisterTransaction bit,
@StoreID uniqueidentifier,
@CustomerID uniqueidentifier,
@Debit money,
@Credit money,
@StartSaleTime datetime,
@EndSaleTime datetime,
@Rounding money,
@Note nvarchar(4000),
@Status smallint)

AS 
--check for duplicate.
Declare @chargedAmt money
set @chargedAmt = (Select debit from [Transaction] Where CustomerID = @CustomerID AND dbo.getday(StartSaleTime) = @StartSaleTime AND Status > -1 And TransactionNo like 'EL%' And TransactionType = 4) 
IF (@chargedamt > 0) 
Begin
raiserror('Charge already done!', 18, 1)
return -1
end
--end check for duplicate

declare @CurrBalance money
set @CurrBalance = isnull((Select BalanceDoe from Customer Where customerid=@CustomerID),0)+isnull(@Debit,0) - isnull(@Credit,0)

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @Date datetime
set  @Date =dbo.GetLocalDATE()

Set @TransactionNo = 'EL-' + cast(DBO.GetMaxNumber('EL') + 1 as nvarchar(5))  

INSERT INTO dbo.[Transaction]
            (TransactionID, TransactionNo, TransactionType, RegisterTransaction,BatchID, StoreID, CustomerID,  
			Debit, Credit, StartSaleTime,EndSaleTime, DueDate,LeftDebit,Freight, Tax, TaxID,  TaxType,TaxRate,
			Rounding, ShipTo, ShipVia,PONo, RepID ,TermsID ,PhoneOrder,ToPrint,ToEmail,CustomerMessage,
                      	Note, ResellerID,DeliveryDate, TrackNo, Status, DateCreated, UserCreated, DateModified, UserModified,CurrBalance)

VALUES     	(@TransactionID, @TransactionNo, @TransactionType,@RegisterTransaction, NULL, @StoreID, @CustomerID,  
			@Debit, @Credit, @StartSaleTime,@EndSaleTime, NULL,@Debit ,NULL,NULL,NULL,NULL,NULL,  
			@Rounding, NULL, NULL,NULL, NULL ,NULL ,NULL,NULL,NULL,NULL,
			@Note, NULL,NULL, NULL, isnull(@Status,1), @Date, NULL, @Date, NULL,@currBalance)

BEGIN
 UPDATE Customer set BalanceDoe= (IsNull(BalanceDoe,0)+@Debit-@Credit),DateModified =dbo.GetLocalDATE() WHERE CustomerID = @CustomerID
END

EXEC [dbo].[SP_UpdateRuningBalance] @TransactionID = @TransactionID

select @UpdateTime as DateModified
GO