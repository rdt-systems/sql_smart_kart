SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/************************************************************************************************
Alex Abreu
2-17-2016
Procedure to ALTER the Receive with returned items
************************************************************************************************/
CREATE PROCEDURE [dbo].[SP_ReturnToVendor](
@DamageItemCollection nvarchar(4000), 
@ModifierID UniqueIdentifier,
@StoreID UniqueIdentifier)
as 
Begin
	
	DECLARE @CurSupplier CURSOR
	Declare @SupplierMain Uniqueidentifier

	Declare @SupplierID Uniqueidentifier
	Declare @ItemStoreID Uniqueidentifier
	Declare @Qty int
	Declare @QtySum int
	Declare @ActualDate datetime

	Declare @Cost Money
	Declare @ExtCost money

	Declare @BillNo nvarchar(50)
	Declare @value nvarchar(50)

	Declare @BillIDx Uniqueidentifier
	Declare @ReceiveID UniqueIdentifier

	Declare @ReceiveEntryID UniqueIdentifier
	Declare @PcCost money
	Declare @CsCost money
	Declare @CaseQty decimal
	DECLARE @CurEntries CURSOR
	Declare @UOMType int
	Declare @Order int
	Declare @TransactionEntryID uniqueidentifier
	Declare @DamageItemID UniqueIdentifier
	Declare @ItemID Uniqueidentifier

	--ALTER a Receive for each Supplier
	Set @CurSupplier = CURSOR FOR
	select distinct SupplierID from DamageItemView where Usermodified = @ModifierID

	OPEN @CurSupplier
	FETCH NEXT FROM @CurSupplier 
	INTO @SupplierMain
	
	--BEGIN TRAN
	--LOOP TO ALTER A RECEIVE FOR EACH SUPPLIER
	WHILE @@FETCH_STATUS = 0
    BEGIN

				--Take the values from DamageView
				set @ActualDate = dbo.GetLocalDATE()



				--Select the sum of quantities, Put Qty Minus
				SELECT    @QtySum =     SUM((0 - DamageItemView.Qty) * ItemMainAndStoreView.[Pc Cost])
				FROM            DamageItemView INNER JOIN
                         ItemMainAndStoreView ON DamageItemView.ItemStoreID = ItemMainAndStoreView.ItemStoreID
				WHERE        (DamageItemView.UserModified = @ModifierID) AND (DamageItemView.SupplierID = @SupplierMain)
	
				--select @QtySum = sum(Qty) * -1 from DamageItemView where Usermodified = @ModifierID and SupplierID = @SupplierMain
				select @SupplierID = SupplierID from DamageItemView where Usermodified = @ModifierID and SupplierID = @SupplierMain


				--Read information from Itemstore				
				--select @Cost = sum(Cost) * @QtySum from ItemStore where ItemstoreID 
				--in (select ItemStoreID from DamageItemView where Usermodified = @ModifierID and SupplierID = @SupplierMain)

				--Get a new Bill number
				Exec SP_GetNewNumber NULL ,'ReceiveOrder',10001
				set @value = (SELECT TOP(1) SeqNumber AS NewNumber FROM NumberSettings WHERE TableName = 'ReceiveOrder' AND (StoreID=@StoreID  OR @StoreID IS NULL))
				set @BillNo = 'Return-' +  ISNULL(@value,1)


				--ALTER the new Bill ID
				set @BillIDx = NEWID()


				--Insert the Bill Record
				Exec [dbo].[SP_BillInsert] @BillIDx,@BillNo,@SupplierID,NULL,@QtySum,NULL, @ActualDate ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,@ModifierID


				--Insert the Receive Record
				set @ReceiveID = NewID()
				Exec [dbo].[SP_ReceiveOrderInsert] @ReceiveID, NULL, @StoreID, @SupplierID, @BillIDx, NULL, NULL, NULL, NULL, NULL, @QtySum, @ActualDate, 0, NULL, 1, NULL, @ModifierID

				set @UOMType = 0
				set @Order = 0

				Set @CurEntries = CURSOR FOR
SELECT        DamageItemView.ItemStoreID, (0 - DamageItemView.Qty)  AS Qty, DamageItemView.SupplierID, DamageItemView.TransactionEntryID, DamageItemView.DamageItemID, ItemStore.Cost, 
                         ItemStore.ItemNo
FROM            DamageItemView INNER JOIN
                         ItemStore ON DamageItemView.ItemStoreID = ItemStore.ItemStoreID
WHERE        (DamageItemView.UserModified = @ModifierID) AND (DamageItemView.SupplierID = @SupplierMain)

				OPEN @CurEntries
				FETCH NEXT FROM @CurEntries 
				INTO @ItemStoreID, @Qty, @SupplierID, @TransactionEntryID, @DamageItemID, @Cost, @ItemID
	
				--LOOP TO ALTER A ENTRY FOR EACH ITEM
				WHILE @@FETCH_STATUS = 0
				BEGIN

					set @Order = @Order + 1
					
					--Get cost from ItemStore
					Select @ExtCost = @Qty * @Cost

					-- Get Pc, Case Cost and CaseQty
					Select @PcCost = [Pc Cost], @CsCost = [Cs Cost], @CaseQty = CaseQty from ItemMainAndStoreView Where ItemID = @ItemID
					--Insert the ReceiveEntry
					set @ReceiveEntryID = NewID()

					Update TransactionEntry set TransactionEntryType = 0 where TransactionEntryID = @TransactionEntryID
					Exec [dbo].[SP_ReceiveEntryInsert] @ReceiveEntryID, @ReceiveID, @ItemStoreID, NULL, @Cost, @Qty, @ExtCost, NULL, @Qty, @UOMType, NULL, NULL, NULL, @Order, NULL, @Cost, 1, @CsCost, @PcCost, @CaseQty, NULL, NULL, @ModifierID, @SupplierID, NULL, NULL, 0, NULL,0
					
					update DamageItem set DamageStatus = 2, Usermodified = NULL where DamageItemID = @DamageItemID And ItemStoreID = @ItemStoreID
					print @DamageItemID

					FETCH NEXT FROM @CurEntries 
					INTO @ItemStoreID, @Qty, @SupplierID, @TransactionEntryID, @DamageItemID, @Cost, @ItemID

				END

	CLOSE @CurEntries;
	DEALLOCATE @CurEntries;

	
				FETCH NEXT FROM @CurSupplier 
				INTO @SupplierMain
	END


	CLOSE @CurSupplier;
	DEALLOCATE @CurSupplier;

	--COMMIT TRAN
	IF @BillNo IS NULL 
	Set @BillNo = 'Return-1'
	SELECT @BillNo
	
End
GO