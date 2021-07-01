SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE Procedure [dbo].[SP_Shopify_Products_New]
AS
SELECT        REPLACE(ISNULL(P.Name,C.Name), ' ', '-') AS Handle,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY ISNULL(P.Name,C.Name) ORDER BY C.Matrix2, C.Matrix1) = 1 THEN  ISNULL(P.Name,C.Name) ELSE '' END AS Title,
'Blew Boutique' AS Vendor,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY ISNULL(P.Name,C.Name) ORDER BY C.Matrix2, C.Matrix1) = 1 THEN  ISNULL(P.Name,C.Name) ELSE '' END AS Tags,
'TRUE' AS Published,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY ISNULL(P.Name,C.Name) ORDER BY C.Matrix2, C.Matrix1) = 1 and C.ItemType = 1 THEN 'Color' ELSE '' END AS [Option1 Name],
ISNULL(C.Matrix1,'') AS [Option1 Value],
CASE WHEN ROW_NUMBER() OVER(PARTITION BY ISNULL(P.Name,C.Name) ORDER BY C.Matrix2, C.Matrix1) = 1 and C.ItemType = 1 THEN'Size' ELSE '' END AS [Option2 Name],
ISNULL(C.Matrix2,'') AS [Option2 Value],
''''+ C.BarcodeNumber AS [Variant SKU],
'' AS [Variant Grams],
'shopify' AS[Variant Inventory Tracker],
S.OnHand AS [Variant Inventory Qty],
'deny' AS [Variant Inventory Policy],
'manual' AS [Variant Fulfillment Service],
S.Price AS [Variant Price],
S.IsTaxable AS [Variant Taxable],
''''+ C.BarcodeNumber AS [Variant Barcode]
FROM            ItemMain AS C  INNER JOIN
                         ItemStore AS S ON C.ItemID = S.ItemNo 
						 LEFT OUTER JOIN
						 ItemMain AS P ON C.LinkNo = P.ItemID and P.ItemType = 2
WHERE       (C.ItemType <> 2) AND (S.Status > 0) AND (C.Status > 0)  and Exists (select * from ItemMain m join ItemStore I on m.ItemID = I.ItemNo where 
m.Status > 0 and I.Status > 0 and I.OnHand > 0  and(I.ItemStoreID = S.ItemStoreID OR m.ItemID = P.LinkNo))
ORDER BY Handle, Title Desc, C.Matrix2, C.Matrix1
GO