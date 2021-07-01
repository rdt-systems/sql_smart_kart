SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GenPurchaseUpdate]
(
@GenPurchaseOrderID uniqueidentifier,
@ItemNo	uniqueidentifier,
@SupplierNo	uniqueidentifier,
@UOMType	int,
@ToOrder 	bit,
@Reorder 	float,--decimal(19, 2),
@SortOrder int,
@Status 	smallint,
@ModifierID uniqueidentifier,
@DateModified datetime

)

AS

if @SortOrder is null

begin
set @SortOrder = (Select MAX(SortOrder) from GenPurchaseOrder) + 1
end

UPDATE dbo.GenPurchaseOrder  
      
SET  

[GenPurchaseOrderID]=@GenPurchaseOrderID ,[ItemNo]=@ItemNo,[Supplier]=@SupplierNo,[ToOrder]=@ToOrder,[ReorderQty]=@Reorder,[UOMType]=@UOMType, [Status]=@Status ,[DateModified]= dbo.GetLocalDATE(), SortOrder=@SortOrder

WHERE  ([GenPurchaseOrderID]=@GenPurchaseOrderID )

IF @@ROWCOUNT=0

EXEC	[dbo].[SP_GenPurchaseInsert]
		@GenPurchaseOrderID = @GenPurchaseOrderID ,
		@ItemNo = @ItemNo,
		@SupplierNo = @SupplierNo,
		@ToOrder = @ToOrder,
		@UOMType = @UOMType,
		@Reorder = @Reorder,
		@SortOrder = @SortOrder,
		@Status = @Status,
		@ModifierID = @ModifierID
GO