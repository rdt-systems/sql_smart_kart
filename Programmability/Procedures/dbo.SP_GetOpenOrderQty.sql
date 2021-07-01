SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOpenOrderQty](@ItemStoreNo uniqueidentifier)
AS SELECT     ItemNo, OrderDeficit
FROM         dbo.PurchaseOrderEntryView
WHERE     (OrderDeficit > 0) AND (ItemNo = @ItemStoreNo) AND (Status > - 1)
GO