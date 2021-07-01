SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionUpdate]
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
@DeliveryDate DateTime,
@TrackNo nvarchar(50),
@Note nvarchar(4000),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@ResellerID uniqueIdentifier=null)


AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OldTime datetime
set  @OldTime =(Select StartSaleTime From [transaction] Where TransactionID=@TransactionID)

DECLARE @OldTransactionBalance Money -- Old Balance
Set @OldTransactionBalance = (Select Debit - Credit  From dbo.[Transaction]  where TransactionID = @TransactionID)

declare @OldCustomerID uniqueidentifier
Set @OldCustomerID=(Select CustomerID From [transaction] Where TransactionID=@TransactionID)

declare @OldDateModified datetime
Set @OldDateModified=(Select DateModified From [transaction] Where TransactionID=@TransactionID)


--transaction
UPDATE dbo.[Transaction]
              
SET   TransactionNo=@TransactionNo,
	TransactionType= @TransactionType, 
	RegisterTransaction=@RegisterTransaction,
	BatchID=@BatchID, 
	StoreID=@StoreID, 
	CustomerID=@CustomerID,
	Debit=round(@Debit,2),
	Credit= round(@Credit,2),
    StartSaleTime=@EndSaleTime,
	EndSaleTime=@EndSaleTime,
	DueDate=@DueDate,
	LeftDebit=round(
        isnull(round(@Debit,2),0)-
        isnull((select sum(isnull(amount,0)) from PaymentDetails Where TransactionPayedID=[Transaction].TransactionID and Status>0 ),0)
	,2),
    Freight=@Freight,
    Tax=@Tax,
    TaxID= @TaxID, 
    TaxType=@TaxType,
	TaxRate=@TaxRate,		
	Rounding=@Rounding,
	ShipTo=@ShipTo,
	ShipVia=@ShipVia, 
	PONo=@PONo,
	RepID=@RepID,
	TermsID=@TermsID,
	PhoneOrder=@PhoneOrder,
	ToPrint=@ToPrint,
	ToEmail=@ToEmail,
	CustomerMessage=@CustomerMessage,
    Note=@Note, 
	DeliveryDate=@DeliveryDate ,
	TrackNo=@TrackNo ,
	Status=@Status,
	DateModified=@UpdateTime,
	UserModified=@ModifierID,
	ResellerID=@ResellerID
 WHERE  (TransactionID= @TransactionID) and  (DateModified = @DateModified or DateModified is NULL)

--W_transaction
UPDATE W_Transaction
              
SET     TransactionNo=@TransactionNo,
	TransactionType= @TransactionType, 
	RegisterTransaction=@RegisterTransaction,
	BatchID=@BatchID, 
	StoreID=@StoreID, 
	CustomerID=@CustomerID,
	Debit=round(@Debit,2),
	Credit= round(@Credit,2),
    StartSaleTime=@EndSaleTime,
	EndSaleTime=@EndSaleTime,
	DueDate=@DueDate,
	LeftDebit=round(
        isnull(round(@Debit,2),0)-
        isnull((select sum(isnull(amount,0)) from PaymentDetails Where TransactionPayedID=W_Transaction.TransactionID and Status>0 ),0)
	,2),
    Freight=@Freight,
    Tax=@Tax,
    TaxID= @TaxID, 
    TaxType=@TaxType,
	TaxRate=@TaxRate,		
	Rounding=@Rounding,
	ShipTo=@ShipTo,
	ShipVia=@ShipVia, 
	PONo=@PONo,
	RepID=@RepID,
	TermsID=@TermsID,
	PhoneOrder=@PhoneOrder,
	ToPrint=@ToPrint,
	ToEmail=@ToEmail,
	CustomerMessage=@CustomerMessage,
    Note=@Note, 
	DeliveryDate=@DeliveryDate ,
	TrackNo=@TrackNo ,
	Status=@Status,
	DateModified=@UpdateTime,
	UserModified=@ModifierID,
	ResellerID=@ResellerID
 WHERE  (TransactionID= @TransactionID) and  (DateModified = @DateModified or DateModified is NULL)


if  (@OldDateModified = @DateModified or @OldDateModified is NULL)
begin

if @CustomerID is not null
	exec UpdateToTransaction @startsaletime,@CustomerID,@OldTime
if @OldCustomerID is not null and @CustomerID<>@OldCustomerID
	exec CustomerBalanceUpdate @OldCustomerID



         

end
select @UpdateTime as DateModified
GO