SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TransactionEntryInsert]
(@TransactionEntryID uniqueidentifier,
@TransactionID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Sort int,
@TransactionEntryType int,
@Taxable bit,
@Qty decimal(19,3),
@UOMPrice money,
@Total money,
@RegUnitPrice money,
@DiscountPerc decimal(19,3),
@DiscountAmount money,
@UOMType int,
@UOMQty decimal(19,3),
@SaleCode  nvarchar(50),
@PriceExplanation nvarchar(50),
@ParentTransactionEntry uniqueidentifier,
@cost money,
@AVGCost money,
@Note nvarchar(50),
@ReturnReason int,
@DepartmentID uniqueidentifier,
@DiscountOnTotal decimal(19,3),
@Status smallint,
@ModifierID uniqueidentifier,
@TotalAfterDiscount decimal(19,3) = NULL,
@TaxRate decimal(18, 4) =0,
@TaxID uniqueidentifier =null,
@ReturenTransID uniqueidentifier= null,
@UpdateParent bit =1,
@Description nvarchar(500) = NULL,
@DiscountReasonID int=0) 
AS 

Declare @RetID uniqueidentifier

IF (SELECT COUNT(*) FROM dbo.TransactionEntry WITH (NOLOCK) WHERE TransactionEntryID=@TransactionEntryID)>0
  RETURN


Declare @Date datetime
SELECT @Date = EndSaleTime from dbo.[Transaction] WITH (NOLOCK) Where TransactionID = @TransactionID


SET XACT_ABORT ON;
BEGIN TRANSACTION
INSERT INTO dbo.TransactionEntry
                 (TransactionEntryID, TransactionID,ItemStoreID, Sort, TransactionEntryType,Taxable, Qty, UOMPrice,UOMType,
                  UOMQty,Total,RegUnitPrice, SaleCode,DiscountPerc,DiscountAmount,ReturnReason,PriceExplanation, 
                  ParentTransactionEntry, cost,AVGCost, DepartmentID,DiscountOnTotal, Status,Note,DateCreated, UserCreated, 
                  DateModified, UserModified,TotalAfterDiscount,TaxRate ,TaxID,DiscountInt)
VALUES      (@TransactionEntryID, @TransactionID,
	   @ItemStoreID, @Sort, @TransactionEntryType
	   , @Taxable, @Qty, @UOMPrice,@UOMType,@UOMQty,round(@Total,2),@RegUnitPrice, @SaleCode, @DiscountPerc, @DiscountAmount,@ReturnReason,
	   @PriceExplanation, @ParentTransactionEntry, @cost, @AVGCost,@DepartmentID,@DiscountOnTotal,   isnull(@Status,1), @Note,  dbo.GetLocalDATE(), 
	   @ModifierID,  dbo.GetLocalDATE(), @ModifierID,@TotalAfterDiscount,@TaxRate ,@TaxID,@DiscountReasonID)

if (@Status = 1) and (@TransactionEntryType<>2) and (@TransactionEntryType <> 11)
begin
  exec UpdateToTransactionEntry @Total,@Qty,@ItemStoreID,@TransactionEntryType,@ModifierID,@UpdateParent
end

if @TransactionEntryType=2 --and @ReturnReason=0
begin
	declare @DamageItem uniqueidentifier
	set @DamageItem=newid()
	declare @DamageDate datetime
	set @DamageDate=@Date
	Declare @NewQty Decimal(19,3)
	set @NewQty=@qty*-1
	exec dbo.SP_DamageItemInsert @DamageItem,@ItemStoreID,@NewQty,0,@TransactionEntryID,null,@DamageDate,1,@ModifierID
end

if @ReturenTransID IS NOT NULL AND @Status>0
BEGIN
  SELECT @RetID = TransactionID From dbo.TransactionEntry WITH (NOLOCK) where TransactionEntryID = @ReturenTransID
  DECLARE @Q as decimal(19,3)
  SET @Q= -@qty 
  exec SP_TransReturenInsert @SaleTransEntryID =@TransactionEntryID,@Qty =@Q,@ReturenTransID= @ReturenTransID
  Update TransactionEntry Set DateModified = dbo.GetLocalDate() Where  TransactionID = @RetID
  Update [Transaction] Set DateModified = dbo.GetLocalDate() Where  TransactionID = @RetID
END

IF @Description IS NOT NULL
Begin
Insert Into EntryDescription (TransactionEntryID,Description)
VALUES (@TransactionEntryID, @Description)
End

COMMIT TRANSACTION;

if (@TransactionEntryType <> 2) and (@TransactionEntryType <> 11) 
Begin
UPDATE       ItemStore
SET                LastSoldDate = CAST(@Date as date) Where ItemStoreID = @ItemStoreID
End
--ALTER PROCEDURE UpdateToTransactionEntry
--(@Total  decimal(19,3),
--@Qty decimal(19,3),
--@ItemStoreID uniqueidentifier,
--@TransactionEntryType int,
--@ModifierID uniqueidentifier)
--as
--IF (@TransactionEntryType<>2) --not return item entry
--	UPDATE dbo.ItemStore
--	SET 	OnHand = isnull(OnHand,0) - @Qty , 
--		MTDQty=isnull(MTDQty,0)+@Qty, 
--		PTDQty=isnull(PTDQty,0)+@Qty, 
--		YTDQty=isnull(YTDQty,0)+@Qty, 
--		MTDDollar=isnull(MTDDollar,0)+ ROUND(@Total,2), 
--		PTDDollar=isnull(PTDDollar,0)+ ROUND(@Total,2),
--		YTDDollar=isnull(YTDDollar,0)+ ROUND(@Total,2),
--		DateModified = dbo.GetLocalDATE(), 
--		UserModified = @ModifierID
--	WHERE ItemStoreID = @ItemStoreID
--ELSE
--	UPDATE dbo.ItemStore
--	SET 	OnHand = isnull(OnHand,0)-@Qty, 
--		MTDReturnQty=isnull(MTDReturnQty,0)-@Qty,  -- Qty Is Minus in case of return item so it comes out plus 
--		PTDReturnQty=isnull(PTDReturnQty,0)-@Qty,
--		YTDReturnQty=isnull(YTDReturnQty,0)-@Qty, 
--	 	DateModified = dbo.GetLocalDATE(), 
--		UserModified = @ModifierID
--	WHERE ItemStoreID = @ItemStoreID
--
--EXEC UpdateParent @ItemStoreID,@ModifierID,1,0,0






/*DECLARE @ParentID uniqueidentifier

Declare @TransactionType int
Set @TransactionType = (Select top 1 TransactionType from [Transaction] Where  TransactionId =@TransactionID)


Declare @BarCode nvarchar(50)
Set       @BarCode = (SELECT     BarcodeNumber FROM   dbo.ItemMainAndStoreView WHERE    ItemStoreID = @ItemStoreID)

If (@TransactionType !=  9 And @TransactionType != 4 And @BarCode != '9999')
Begin
	If  @TransactionEntryType <> 6   -- Check if TransactionEntryType is not Return Item 
   	BEGIN 
		UPDATE dbo.ItemStore
   		SET OnHand = OnHand - @Qty,MTDQty=MTDQty+@Qty, PTDQty=PTDQty+@Qty, YTDQty=YTDQty+@Qty, MTDDollar=MTDDollar+ ROUND(@Qty* @Price,2), 
		PTDDollar=PTDDollar+ ROUND(@Qty* @Price,2),YTDDollar=YTDDollar+ ROUND(@Qty* @Price,2),
	 	DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
   		WHERE ItemStoreID = @ItemStoreID

		SET @ParentID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)

		IF   (@ParentID is not null)
		BEGIN
   	 		UPDATE  dbo.ItemStore
   			SET  OnHand =   (OnHand - @Qty),MTDQty=MTDQty+@Qty, PTDQty=PTDQty+@Qty, YTDQty=YTDQty+@Qty, MTDDollar=MTDDollar+ ROUND(@Qty* @Price,2), 
			PTDDollar=PTDDollar+ ROUND(@Qty* @Price,2),YTDDollar=YTDDollar+ ROUND(@Qty* @Price,2)
			, DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
    			WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where ItemStoreID=@ItemStoreID)  AND  (ItemNo = @ParentID))
		END
	END

	ELSE

	BEGIN
		UPDATE dbo.ItemStore
   		SET MTDReturnQty=MTDReturnQty-@Qty,PTDReturnQty=PTDReturnQty-@Qty,YTDReturnQty=YTDReturnQty-@Qty , -- Qty Is Minus in case of return item so it comes out plus 
	 	DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
   		WHERE ItemStoreID = @ItemStoreID

		SET @ParentID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)

		IF   (@ParentID is not null)
		BEGIN
   	 		UPDATE  dbo.ItemStore
   			SET  MTDReturnQty=MTDReturnQty-@Qty,PTDReturnQty=PTDReturnQty-@Qty,YTDReturnQty=YTDReturnQty-@Qty,  -- Qty Is Minus in case of return item so it comes out plus 
	 	                DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
    			WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where ItemStoreID=@ItemStoreID)  AND  (ItemNo = @ParentID))
		END

	END
END*/
GO