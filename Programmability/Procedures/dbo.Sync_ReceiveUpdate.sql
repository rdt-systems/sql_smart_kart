SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ReceiveUpdate]
(
@ReceiveID uniqueidentifier,
@ReceiveNo nvarchar(50),
@ReceiveDate datetime,
@Credit money,
@Debit money,
@Paid decimal(18,3),
@SupplierID uniqueidentifier,
@Note nvarchar(4000),
@RowType int,
@PaymentType int,
@CheckNo nvarchar(50),
@CheckDate datetime,
@Discount decimal(18,3),
@DiscountType int,
@StoreID uniqueidentifier,
@DateModified datetime=null,
@ModifierID uniqueidentifier)


as

IF @RowType = 4
begin 
	Declare @BillID uniqueidentifier
	Set @BillID = (SELECT BillID FROM dbo.ReceiveOrder where ReceiveID = @ReceiveID)

	exec UpdateReceiveEntry @ReceiveID,-1,@ModifierID


	UPDATE dbo.ReceiveOrder
	SET
		ReceiveOrderDate = @ReceiveDate,
		SupplierNo = @SupplierID,
		Note = @Note,
		Total = ROUND(@Debit,2),
		StoreID = @StoreID,
		Discount = (CASE WHEN @DiscountType=2 THEN ROUND(@Discount / (@Debit + @Discount) * 100,2) ELSE ROUND(@Discount,2) END),
		IsDiscAmount = (CASE WHEN @DiscountType=2 THEN 1 ELSE 0 END ),
		DateModified = dbo.GetLocalDATE(),
		UserModified =@ModifierID 
	WHERE
		ReceiveID = @ReceiveID

	UPDATE dbo.Bill
	SET
		BillNo = @ReceiveNo,
		BillDate = @ReceiveDate,
		BillDue = @ReceiveDate,
		SupplierID = @SupplierID,
		Amount = ROUND(@Debit,2),
		DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	WHERE
		BillID = @BillID
		

	--Delete pay to bill

		DECLARE @PayToBillID uniqueidentifier

		DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT PayToBillID
		FROM dbo.PayToBill 
		WHERE(BillID=@BillID) 

			
		OPEN c2

		FETCH NEXT FROM c2 
		INTO @PayToBillID   

		WHILE @@FETCH_STATUS = 0
			BEGIN
				exec	[SP_PayToBillDelete] @PayToBillID, @ModifierID
			FETCH NEXT FROM c2    --insert the next values to the instance
				INTO @PayToBillID
			END
			
		CLOSE c2
		DEALLOCATE c2
	
end  
else if @RowType = 5
begin

	UPDATE dbo.ReturnToVender
	SET
		ReturnToVenderDate = @ReceiveDate,
		SupplierID = @SupplierID,
		Note = @Note,
		StoreNo = @StoreID,
		ReturnToVenderNo = @ReceiveNo,
		Total = ROUND(ABS(@Credit),2),
		DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	WHERE
		ReturnToVenderID = @ReceiveID
	
		DECLARE @PayToBill uniqueidentifier

		DECLARE c2 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT PayToBillID
		FROM dbo.PayToBill 
		WHERE(SuppTenderID=@ReceiveID) 

			
		OPEN c2

		FETCH NEXT FROM c2 
		INTO @PayToBill  

		WHILE @@FETCH_STATUS = 0
			BEGIN
				exec	[SP_PayToBillDelete] @PayToBillID, @ModifierID
			FETCH NEXT FROM c2    --insert the next values to the instance
				INTO @PayToBill
			END
			
		CLOSE c2
		DEALLOCATE c2
	
end
else if @RowType = 6
begin
	UPDATE dbo.SupplierTenderEntry
	SET
		SuppTenderNo = @ReceiveNo,
		SupplierID = @SupplierID,
		TenderDate = @ReceiveDate,
		TenderID = ISNULL(@PaymentType,1),
		Common1 = @CheckNo,
		Common4 = @CheckDate,
		Amount = ISNULL(ROUND(@Credit,2),0),
		StoreID = @StoreID,
		DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	WHERE 
		SuppTenderEntryID = @ReceiveID
	
end
GO