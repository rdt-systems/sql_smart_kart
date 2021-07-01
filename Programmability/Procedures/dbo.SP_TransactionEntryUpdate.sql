SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TransactionEntryUpdate]
(@TransactionEntryID uniqueidentifier,
@TransactionID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Sort int,
@TransactionEntryType int,
@Taxable bit,
@Qty decimal(19,3),
@UOMPrice money,
@DiscountPerc decimal(19,3),
@DiscountAmount money,
@UOMType int,
@UOMQty decimal(19,3),
@Total money,
@RegUnitPrice money,
@SaleCode  nvarchar(50),
@PriceExplanation nvarchar(50),
@ParentTransactionEntry uniqueidentifier,
@cost money,
@AVGCost money,
@Note nvarchar(50),
@ReturnReason int,
@DepartmentID uniqueidentifier,
@DiscountOnTotal decimal(19,3)= null,
@Status smallint,
@DateModified datetime = null,
@ModifierID uniqueidentifier,
@TotalAfterDiscount decimal(19,3) = NULL,
@TaxRate decimal(18, 4) =0,
@TaxID uniqueidentifier =null,
@Description nvarchar(500) = NULL)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OldItem uniqueidentifier
DECLARE @OldQty decimal(19,3)
DECLARE @OldTransactionEntryType int
DECLARE @OldReturnReason int
DECLARE @OldStatus int

SELECT top(1) @OldItem=ItemStoreID,@OldQty=Qty,@OldTransactionEntryType=TransactionEntryType,@OldReturnReason=ReturnReason, @OldStatus=Status
       FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID

--SET @OldItem =(SELECT ItemStoreID FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)


--SET @OldQty = (SELECT Qty FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)


--SET @OldTransactionEntryType = (SELECT TransactionEntryType FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)


--SET @OldReturnReason = (SELECT ReturnReason FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)





UPDATE    dbo.TransactionEntry

SET      TransactionID =@TransactionID ,
	 ItemStoreID = @ItemStoreID ,
	 Sort = @Sort,
	 TransactionEntryType = @TransactionEntryType,
	 Taxable = @Taxable,   
     Qty=@Qty,
	 UOMPrice =@UOMPrice,
	 DiscountPerc=@DiscountPerc,
	 DiscountAmount=@DiscountAmount,
	 UOMType=@UOMType,
 	 UOMQty=@UOMQty,
	 Total=round(@Total,2),
	 RegUnitPrice=@RegUnitPrice,
	 SaleCode=@SaleCode, 
	 PriceExplanation =@PriceExplanation,
     ParentTransactionEntry = @ParentTransactionEntry , 
	 Cost=@cost,
     AVGCost=@AVGCost,
	 DepartmentID=@DepartmentID,
	 DiscountOnTotal=@DiscountOnTotal ,
	 Status  = @Status,
     Note = @Note, 
	 ReturnReason =@ReturnReason,
     DateModified = @UpdateTime, 
	 UserModified = @ModifierID,
	 TotalAfterDiscount = @TotalAfterDiscount, 
     TaxRate= @TaxRate,
     TaxID= @TaxID 
WHERE    (TransactionEntryID=@TransactionEntryID ) --and  (DateModified = @DateModified or DateModified is NULL)

--UPDATE    dbo.W_TransactionEntry

--SET      TransactionID =@TransactionID ,
--	 ItemStoreID = @ItemStoreID ,
--	 Sort = @Sort,
--	 TransactionEntryType = @TransactionEntryType,
--	 Taxable = @Taxable,   
--     Qty=@Qty,
--	 UOMPrice =@UOMPrice,
--	 DiscountPerc=@DiscountPerc,
--	 DiscountAmount=@DiscountAmount,
--	 UOMType=@UOMType,
-- 	 UOMQty=@UOMQty,
--	 Total=round(@Total,2),
--	 RegUnitPrice=@RegUnitPrice,
--	 SaleCode=@SaleCode, 
--	 PriceExplanation =@PriceExplanation,
--     ParentTransactionEntry = @ParentTransactionEntry , 
--	 Cost=@cost,
--     AVGCost=@AVGCost,
--	 DepartmentID=@DepartmentID,
--	 DiscountOnTotal=@DiscountOnTotal ,
--	 Status  = @Status,
--     Note = @Note, 
--	 ReturnReason =@ReturnReason,
--     DateModified = @UpdateTime, 
--	 UserModified = @ModifierID
--WHERE    (TransactionEntryID=@TransactionEntryID ) and  (DateModified = @DateModified or DateModified is NULL)

IF @Description IS NOT NULL
Begin
	IF EXISTS (SELECT * From EntryDescription Where TransactionEntryID = @TransactionEntryID)
	UPDATE EntryDescription Set Description = @Description
ELSE
	Insert Into EntryDescription (TransactionEntryID,Description)
	VALUES (@TransactionEntryID, @Description)
End


if @ItemStoreID=@OldItem
begin
	--IF THE ITEM DIDNT CHANGED 
	set @OldQty=@Qty-@OldQty
    exec UpdateToTransactionEntry @Total,@OldQty,@ItemStoreID,@TransactionEntryType,@ModifierID
end
else
begin
	--UPDATE THE NEW 
    exec UpdateToTransactionEntry @Total,@Qty,@ItemStoreID,@TransactionEntryType,@ModifierID
	set @OldQty=-@OldQty
    exec UpdateToTransactionEntry @Total,@OldQty,@OldItem,@TransactionEntryType,@ModifierID


end
Declare @NewQty Decimal(19,3)
set @NewQty=@qty*-1
if @OldTransactionEntryType=2 and @OldReturnReason=0
begin
	declare @DamageItemID uniqueidentifier
	set @DamageItemID=(Select top 1 DamageItemID from DamageItem where TransactionEntryID=@TransactionEntryID and status>0)

	if @TransactionEntryType=2 and @ReturnReason=0
	begin
		declare @DamageDate datetime
		set @DamageDate=(SELECT EndSaleTime From [transaction] where transactionID=@TransactionID)
		exec dbo.SP_DamageItemUpdate @DamageItemID,@ItemStoreID,@NewQty,0,@TransactionEntryID,null,@DamageDate,1,null,@ModifierID
	end
	else
	begin
		exec dbo.SP_DamageItemDelete @DamageItemID,@ModifierID
	end
end
else
begin
	if @TransactionEntryType=2 and @ReturnReason=0
	begin
		declare @DamageItem uniqueidentifier
		set @DamageItem=newid()
		declare @Date datetime
		set @Date=(SELECT EndSaleTime From [transaction] where transactionID=@TransactionID)
		exec dbo.SP_DamageItemInsert @DamageItem,@ItemStoreID,@NewQty,0,@TransactionEntryID,null,@Date,1,@ModifierID
	end
end

--Check if Change from Send sale the regular Sale then update reserved 
if @OldTransactionEntryType=11 and @TransactionEntryType=0 
begin
 Update ItemStore Set Reserved = IsNull(Reserved,0)-@Qty WHERE (ItemStoreID=@ItemStoreID )
end

select @UpdateTime as DateModified

if @Status<1 and @OldStatus>0 And @ItemStoreID is not null 
BEGIN
	IF (Select Count(*) from RequestTransferEntry WHERE TransactionEntryID =@TransactionEntryID and Status>0)>0
	BEGIN
	    Declare @IT as uniqueidentifier
		SET @IT =(Select Top(1)ItemStoreID from RequestTransferEntry WHERE TransactionEntryID =@TransactionEntryID and Status>0)
		UPDATE RequestTransferEntry Set Status=@Status WHERE TransactionEntryID =@TransactionEntryID  	
		EXEC	[dbo].[OnRequestUpdateOneItem]	@ItemStoreID = @ItemStoreID
		IF @IT is not null
			EXEC [dbo].[SP_UpdateOnHandOneItem]	@ItemStoreID =@IT
	END
END

UPDATE       ItemStore
SET                LastSoldDate =
                             (SELECT        TOP (1) Dbo.GetDay(T.StartSaleTime)
                               FROM            TransactionEntry AS TE INNER JOIN
                                                         [Transaction] AS T ON TE.TransactionID = T.TransactionID
                               WHERE        (TE.ItemStoreID = ItemStore.ItemStoreID) AND (TE.Status > 0) AND (T.Status > 0) AND (TE.TransactionEntryType <> 2)
                               ORDER BY T.StartSaleTime DESC)
							   Where ItemStoreID = @ItemStoreID
GO