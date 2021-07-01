SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_Shopify_Products_Update]
AS
Select C.BarcodeNumber AS SKU, OnHand AS Qty, Price
FROM            ItemMain AS C  INNER JOIN
                         ItemStore AS S ON C.ItemID = S.ItemNo 
						 LEFT OUTER JOIN
						 ItemMain AS P ON C.LinkNo = P.ItemID and P.ItemType = 2
WHERE       (C.ItemType <> 2) AND (S.Status > 0) AND (C.Status > 0)   and Exists (select * from ItemMain m join ItemStore I on m.ItemID = I.ItemNo where 
m.Status > 0 and I.Status > 0 and I.OnHand > 0  and(I.ItemStoreID = S.ItemStoreID OR m.ItemID = P.LinkNo))
ORDER BY C.Name, C.Matrix2, C.Matrix1
GO