SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemListView](@SupplierNo uniqueidentifier,
@Status smallint = 1,
@StoreNo uniqueidentifier, @refreshTime  datetime output)
AS SELECT     dbo.ItemListForSupplierView.*
FROM         dbo.ItemListForSupplierView
WHERE     (SupplierNo = @SupplierNo) AND (Status >= @Status) AND (StoreNo = @StoreNo)
set @refreshTime = dbo.GetLocalDATE()
GO