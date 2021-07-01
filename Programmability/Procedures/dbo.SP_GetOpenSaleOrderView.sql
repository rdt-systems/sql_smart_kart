SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOpenSaleOrderView]
@WOID uniqueidentifier=null
AS
if @WOID=null
	SELECT WOID,ItemStoreID,(Qty-SoldQty) AS QTY,Price
	FROM dbo.OpenSaleOrderView
	WHERE (Qty-SoldQty) > 0
else
	SELECT WOID,ItemStoreID,(Qty-SoldQty) AS QTY,Price
	FROM dbo.OpenSaleOrderView
	WHERE WOID=@WOID AND (Qty-SoldQty) >0
GO