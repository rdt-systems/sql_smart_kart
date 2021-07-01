SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_TransactionInsert]
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
@PaymentType int=1,
@CheckNo nvarchar(50),
@CheckDate datetime,
@signature image =null,
@StoreID uniqueidentifier,
@ResellerID uniqueidentifier,
@ModifierID uniqueidentifier,
@Active bit =1)

AS

Declare @NewId nvarchar (20)
set @NewId = @TransactionNo

if ((select Count(*) from [transaction] where TransactionID=@TransactionID and Status>-1)> 0) 
begin
	 RAISERROR  ('Transaction No Alredy Exists.',20,1) -- WITH LOG
end

if ((select Count(*) from [transaction] where TransactionNo=@NewId and Status>-1)> 0)  and @TransactionType<>7   --SaleOrder
begin
		set @NewId = @TransactionNo + '-' + Right(@TransactionID,3)
end

IF @TransactionType<>7   --SaleOrder
BEGIN

if (SELECT COUNT(*)
	FROM dbo.[Transaction]
	WHERE TransactionID=@TransactionID)>0 RETURN

declare @CurrBalance money
set @CurrBalance = isnull((Select BalanceDoe 
						   from Customer 
						   Where Customerid=@CustomerID),0)+isnull(@Debit,0) - isnull(@Credit,0)

INSERT INTO dbo.[Transaction]
                      (TransactionID, TransactionNo, TransactionType, RegisterTransaction, StoreID, CustomerID,  
			 Credit,Debit, StartSaleTime,EndSaleTime, DueDate,LeftDebit,Freight,PhoneOrder,ToPrint,ToEmail,
                      	Note, Status, DateCreated, UserCreated, DateModified, UserModified,CurrBalance)



VALUES
	(
    @TransactionID,
	@NewId,
	@TransactionType,
	0,
	@StoreID,
	@CustomerID,
	ROUND(@Credit,2),
	ROUND(@Debit,2) ,
	(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
	(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
	(CASE WHEN @TransactionType=0 AND CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate))  WHEN @TransactionType=0 AND CHARINDEX('+',@SaleDate)=0 THEN @SaleDate END),
	ROUND(@Debit,2)-ROUND(@Credit,2) ,
	0,
	0,
	0,
	0,
	@Note,
	1,
	dbo.GetLocalDATE(), 
	@ModifierID, 
	dbo.GetLocalDATE(), 
	@ModifierID,
	@CurrBalance)

exec UpdateToTransaction @SaleDate,@CustomerID

 --Return
DECLARE @AutoApply Bit
SET @AutoApply=(select top 1 OptionValue
				from SetUpValues
				Where StoreID=@StoreID AND OptionID='908')
if @AutoApply=1 AND @TransactionType=3 
exec dbo.SP_ApplyTransaction @TransactionID,@ModifierID

IF @TransactionType=1   --Payment 
INSERT INTO TenderEntry
	
  (TenderEntryID,
   TenderID,
   Common1,
   TenderDate,
   TransactionID,
   TransactionType,
   Amount,
   Status, 
   DateCreated, 
   UserCreated, 
   DateModified, 
   UserModified)

VALUES
    (NEWID(),
	@PaymentType,
	@CheckNo,
	@CheckDate,
	@TransactionID,
	0,
	@Credit,
	1, 
	dbo.GetLocalDATE(), 
	@ModifierID, 
	dbo.GetLocalDATE(), 
	@ModifierID)

END
ELSE     --SaleOrder
BEGIN

if (SELECT COUNT(*)
	FROM dbo.WorkOrder
	WHERE WorkOrderID=@TransactionID)>0 RETURN

INSERT INTO dbo.WorkOrder
                      (WorkOrderID, WONo,StoreID, CustomerID,  
			 Debit, StartSaleTime,EndSaleTime,Tax,
                      	Note,WOStatus,Freight,IsWeb,ResellerID, Status, DateCreated, UserCreated, DateModified, UserModified)



VALUES
	(
    @TransactionID,
	@NewId,
	@StoreID,
	@CustomerID,
	ROUND(@Debit,2) ,
	(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
	(CASE WHEN CHARINDEX('+',@SaleDate)<>0 THEN Left(@SaleDate, CHARINDEX('+',@SaleDate)) ELSE @SaleDate END),
	0,
	@Note,
	1, --Open
	0,
	0,
	@ResellerID,
	1,
	dbo.GetLocalDATE(), 
	@ModifierID, 
	dbo.GetLocalDATE(), 
	@ModifierID)

END

IF @signature IS NOT NULL
	INSERT INTO dbo.SigCapture
	(SigID,[Signature],TransactionID)
	VALUES
	(NEWID(),@signature,@TransactionID)
GO