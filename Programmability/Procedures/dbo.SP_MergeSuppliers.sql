SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MergeSuppliers]
(@FromSupplierID uniqueidentifier,
	@ToSupplierID uniqueidentifier,
	@ModifierID uniqueidentifier = NULL)
As 

IF NOT @FromSupplierID = @ToSupplierID 
BEGIN

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

update dbo.PurchaseOrders
set SupplierNo=@ToSupplierID,
    DateModified = @UpdateTime
where SupplierNo=@FromSupplierID

update dbo.ReceiveOrder
set SupplierNo=@ToSupplierID,
DateModified = @UpdateTime
where SupplierNo=@FromSupplierID

update dbo.ReturnToVender
set SupplierID=@ToSupplierID,
DateModified = @UpdateTime
where SupplierID=@FromSupplierID

--Modified to fix error
BEGIN


DECLARE @ItemStoreID Uniqueidentifier, @IsMain Bit
DECLARE F CURSOR FOR
SELECT        ItemStoreNo, IsMainSupplier
FROM            ItemSupply
WHERE        (SupplierNo = @FromSupplierID)

OPEN F
FETCH NEXT FROM F INTO @ItemStoreID, @IsMain
WHILE @@FETCH_STATUS = 0 BEGIN
EXEC	[dbo].[UpdateSupplierItem]
		@ItemStoreID = @ItemStoreID,
		@SupplierID = @ToSupplierID,
		@MainSupplier = @IsMain,
		@ModifierID = @ModifierID
FETCH NEXT FROM F INTO @ItemStoreID, @IsMain
END
CLOSE F
DEALLOCATE F

UPDATE ItemSupply set Status = - 2, DateModified = dbo.GetLocalDATE() WHERE SupplierNo = @FromSupplierID
END

--Finished Modification

update dbo.SupplierTenderEntry
set SupplierID=@ToSupplierID,
DateModified = @UpdateTime
where SupplierID=@FromSupplierID

update dbo.Bill
set SupplierID=@ToSupplierID,
DateModified = @UpdateTime
where SupplierID=@FromSupplierID

update GenPurchaseOrder set Supplier = @ToSupplierID,
DateModified = @UpdateTime
where Supplier = @FromSupplierID


EXEC dbo.SP_SupplierDelete @FromSupplierID,@ModifierID

END
GO