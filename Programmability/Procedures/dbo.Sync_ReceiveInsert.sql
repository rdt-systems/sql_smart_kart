SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ReceiveInsert]
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
@ModifierID uniqueidentifier)


as

IF @RowType = 4
begin 
 if (SELECT COUNT(*)
 FROM dbo.ReceiveOrder
 WHERE ReceiveID=@ReceiveID)>0 RETURN

 Declare @BillID uniqueidentifier
 Set @BillID=NEWID()

 INSERT INTO dbo.ReceiveOrder
 (
 ReceiveID,
 ReceiveOrderDate,
 SupplierNo,
 BillID,
 Note,
 Total,
 StoreID,
 Freight,
 Discount,
 IsDiscAmount,
 Status,
 DateCreated,
 UserCreated,
 DateModified,
 UserModified
 )
 VALUES
 (
 @ReceiveID,
 @ReceiveDate,
 @SupplierID,
 @BillID,
 @Note,
 ROUND(@Debit,2),
 @StoreID,
 0,
 (CASE WHEN @DiscountType=2 THEN ROUND(@Discount / (@Debit + @Discount) * 100,2) ELSE ROUND(@Discount,2) END),
 (CASE WHEN @DiscountType=2 THEN 1 ELSE 0 END ),
 1,
 dbo.GetLocalDATE(),
 @ModifierID,
 dbo.GetLocalDATE(),
 @ModifierID)

 INSERT INTO dbo.Bill
 (
 BillID,
 BillNo,
 BillDate,
 BillDue,
 SupplierID,
 Amount,
 AmountPay,
 TaxRate,
 Taxable,
 TaxAmount,
 Status,
 DateCreated,
 UserCreated,
 DateModified,
 UserModified
 )
 VALUES
 (
 @BillID,
 @ReceiveNo,
 @ReceiveDate,
 @ReceiveDate,
 @SupplierID,
 ROUND(@Debit,2),
 0,
 0,
 0,
 0,
 1,
 dbo.GetLocalDATE(),
 @ModifierID,
 dbo.GetLocalDATE(),
 @ModifierID
 )
end  
else if @RowType = 5
begin
	if (SELECT COUNT(*)
	FROM dbo.ReturnToVender
	WHERE ReturnToVenderID=@ReceiveID)>0 RETURN

	INSERT INTO dbo.ReturnToVender
	(
	ReturnToVenderID, 
	ReturnToVenderDate,
	SupplierID,
	Note,
	StoreNo,
	ReturnToVenderNo,
	Total,
	TaxRate,
	Taxable,
	TaxAmount,
	Status,
	DateCreated,
	UserCreated,
	DateModified,
	UserModified
	)
	VALUES
	(
	@ReceiveID,
	@ReceiveDate,
	@SupplierID,
	@Note,
	@StoreID,
	@ReceiveNo,
	ROUND(ABS(@Credit),2),
	0,
	0,
	0,
	1,
	dbo.GetLocalDATE(),
	@ModifierID,
	dbo.GetLocalDATE(),
	@ModifierID
	)
end
else if @RowType = 6
begin
 if (SELECT COUNT(*)
 FROM dbo.SupplierTenderEntry
 WHERE SuppTenderEntryID=@ReceiveID)>0 RETURN

 INSERT INTO dbo.SupplierTenderEntry
 (
 SuppTenderEntryID,
 SuppTenderNo,
 SupplierID,
 TenderDate,
 TenderID,
 Common1,
 Common4,
 Amount,
 StoreID,
 Status,
 DateCreated,
 UserCreated,
 DateModified,
 UserModified
 )
 VALUES
 (
 @ReceiveID,
 @ReceiveNo,
 @SupplierID,
 @ReceiveDate,
 ISNULL(@PaymentType,1),
 @CheckNo,
 @CheckDate,
 ISNULL(ROUND(@Credit,2),0),
 @StoreID,
 1,
 dbo.GetLocalDATE(),
 @ModifierID,
 dbo.GetLocalDATE(),
 @ModifierID
 )
end
GO