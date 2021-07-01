SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_TransactionUpdate]
(
@TransactionID uniqueidentifier,
@TransactionNo nvarchar(50),
@SaleDate nvarchar(50),
@CustomerID uniqueidentifier,
@Credit decimal(19,3),
@Debit decimal(19,3),
@TransactionType int,
@Note nvarchar(50),
@Paid decimal(19,3),
@PaymentType int,
@CheckNo nvarchar(50),
@CheckDate datetime,
@signature image = null,
@StoreID uniqueidentifier,
@ResellerID uniqueidentifier,
@DateModified datetime=null,
@ModifierID uniqueidentifier,
@Active bit
)
as

IF @TransactionType<>7 --Sale Order
BEGIN

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OldTime datetime
set  @OldTime =(Select StartSaleTime 
				From [Transaction] 
				Where TransactionID=@TransactionID)

DECLARE @OldTransactionBalance Money -- Old Balance
Set @OldTransactionBalance = (Select Debit - Credit  
							  From dbo.[Transaction]  
							  where TransactionID = @TransactionID)


UPDATE dbo.[Transaction]
SET
	TransactionNo=@TransactionNo,
    StoreID=@StoreID,
	StartSaleTime=(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
	EndSaleTime=(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
    DueDate=(CASE WHEN @TransactionType=0 AND CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate))  WHEN @TransactionType=0 AND CHARINDEX('+',@SaleDate)=0 THEN @SaleDate END),
	LeftDebit=ROUND(isnull(LeftDebit,0)+@debit-@Credit-@OldTransactionBalance,2),
	Note=@Note,
    Debit=(CASE WHEN @TransactionType=3 THEN ROUND(@Debit,2)*-1 ELSE ROUND(@Debit,2) END),
	Credit=ROUND(@Credit,2),
	CustomerID=@CustomerID,
	TransactionType=@TransactionType,
	DateModified=dbo.GetLocalDATE(), 
	UserModified=@ModifierID
  

WHERE TransactionID=@TransactionID 

exec UpdateToTransaction @SaleDate,@CustomerID,@OldTime

--Delete payment details

DECLARE @PaymentID uniqueidentifier

DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT PaymentID
FROM dbo.PaymentDetails 
WHERE(TransactionPayedID=@TransactionID) 

	
OPEN c2

FETCH NEXT FROM c2 
INTO @PaymentID   

WHILE @@FETCH_STATUS = 0
	BEGIN
		exec	[SP_PaymentDetailsDelete] @PaymentID, @ModifierID
	FETCH NEXT FROM c2    --insert the next values to the instance
		INTO @PaymentID
	END
	
CLOSE c2
DEALLOCATE c2

 --Return
DECLARE @AutoApply Bit
SET @AutoApply=(select top 1 OptionValue
				from SetUpValues
				Where StoreID=@StoreID AND OptionID='908')
if @AutoApply=1 AND @TransactionType=3 
exec dbo.SP_ApplyTransaction @TransactionID,@ModifierID

END 

ELSE  --Sale Order
BEGIN

UPDATE dbo.WorkOrder
SET
WONo=@TransactionNo,
StoreID=@StoreID,
CustomerID=@CustomerID,  
Debit=ROUND(@Debit,2),
StartSaleTime=(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
EndSaleTime=(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
Note=@Note,
WOStatus=1,
ResellerID=@ResellerID,
DateModified=dbo.GetLocalDATE(), 
UserModified=@ModifierID


WHERE WorkOrderID=@TransactionID 

END

IF @signature is not null
begin
	IF EXISTS (select 1 from dbo.SigCapture where TransactionID=@TransactionID )   
		UPDATE dbo.SigCapture
		SET 
		[Signature]=@signature

		WHERE TransactionID=@TransactionID

	ELSE
		INSERT INTO dbo.SigCapture
		(SigID,[Signature],TransactionID)
		VALUES
		(NEWID(),@signature,@TransactionID)
end
GO