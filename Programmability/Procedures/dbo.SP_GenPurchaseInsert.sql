SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GenPurchaseInsert]
(
@GenPurchaseOrderID uniqueidentifier,
@ItemNo	uniqueidentifier,
@SupplierNo	uniqueidentifier,
@ToOrder 	bit,
@UOMType	int,
@Reorder	float,--decimal(19, 2),
@SortOrder int,
@Status 	smallint,
@ModifierID uniqueidentifier

)

AS 
if @SortOrder is null

begin
set @SortOrder = (Select MAX(SortOrder) from GenPurchaseOrder) + 1
end


INSERT INTO dbo.GenPurchaseOrder
	 ([GenPurchaseOrderID], [ItemNo], [Supplier], [ToOrder], [ReorderQty], [UOMType],[Status], [DateCreated], [DateModified], [SortOrder])
 VALUES 
(@GenPurchaseOrderID ,@ItemNo, @SupplierNo, @ToOrder, @Reorder, @UOMType, 1, dbo.GetLocalDATE(), dbo.GetLocalDATE(),@SortOrder)
GO