SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GenPurchaseDelete]
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

UPDATE dbo.GenPurchaseOrder  
      
SET  

[GenPurchaseOrderID]=@GenPurchaseOrderID ,[ItemNo]=@ItemNo,[Supplier]=@SupplierNo,[ToOrder]=@ToOrder,[ReorderQty]=@Reorder,[UOMType]=@UOMType, [Status]=@Status ,[DateModified]= dbo.GetLocalDATE()

WHERE  ([GenPurchaseOrderID]=@GenPurchaseOrderID )
GO