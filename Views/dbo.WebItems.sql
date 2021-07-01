SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[WebItems]
--WITH SCHEMABINDING
AS
SELECT  dbo.ItemMain.BarcodeNumber AS sku, dbo.ItemMain.BarcodeNumber AS UPC, dbo.ItemStore.OnHand AS qty, dbo.ItemStore.Price AS price, CASE WHEN ItemStore.SalePrice > 0 THEN dbo.ItemStore.SalePrice ELSE NULL 
                         END AS special_price, 	CONVERT(VARCHAR(10), dbo.ItemStore.SaleStartDate, 120)  AS special_from_date, CONVERT(VARCHAR(10), dbo.ItemStore.SaleEndDate, 120) AS special_to_date
FROM            dbo.ItemMain INNER JOIN
                         dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo
WHERE        (dbo.ItemMain.Status > 0) AND (dbo.ItemStore.Status > 0) 
AND (dbo.ItemStore.DateModified > dbo.GetLocalDate() - 3) 
OR
                         (dbo.ItemMain.Status > 0) AND (dbo.ItemStore.Status > 0) 
AND (dbo.ItemMain.DateModified > dbo.GetLocalDate() - 3)



GO