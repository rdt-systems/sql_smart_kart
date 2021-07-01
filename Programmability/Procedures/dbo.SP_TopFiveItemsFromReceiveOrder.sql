SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TopFiveItemsFromReceiveOrder]	

@ReceiveNo uniqueidentifier

AS
--	SELECT DTOrder.ItemStoreNo, DTOrder.Cost, DTOrder.Qty, DTOrder.UOMType,
--	ReceiveEntryView.PurchaseOrderNo,DTOrder.SortOrder
--	FROM ReceiveEntryView LEFT OUTER JOIN
--	(SELECT ItemStoreNo, Cost, Qty, UOMType
--	,SortOrder = (ROW_NUMBER() OVER(PARTITION BY ItemStoreNo ORDER BY ReceiveEntry.DateCreated DESC ))
--	FROM ReceiveEntry)
--	AS DTOrder ON ReceiveEntryView.ItemStoreNo = DTOrder.ItemStoreNO
--	WHERE DTOrder.SortOrder <6 AND ReceiveEntryView.ReceiveNo = @PON
--    ORDER BY DTOrder.ItemStoreNo,SortOrder

SELECT     DTOrder.Cost,DTOrder.Qty,Price, DTOrder.UOMType, RE.PurchaseOrderNo, DTOrder.SortOrder, ItemMainAndStoreView.Name, 
                      ItemMainAndStoreView.BarcodeNumber, ReceiveWithBill.SuppName, ReceiveWithBill.Num, ReceiveWithBill.DateT, DTOrder.ItemStoreNo
FROM         ItemMainAndStoreView INNER JOIN
                          (SELECT     ItemStoreNo,Cost, Qty,UOMType, (ROW_NUMBER() OVER(PARTITION BY ItemStoreNo ORDER BY ReceiveEntry.DateCreated DESC )) AS SortOrder, ReceiveNo
                            FROM          ReceiveEntry
                            WHERE      (ReceiveNo <> @ReceiveNo)) AS DTOrder ON 
                      ItemMainAndStoreView.ItemStoreID = DTOrder.ItemStoreNo INNER JOIN
                      ReceiveWithBill ON DTOrder.ReceiveNo = ReceiveWithBill.IDc LEFT OUTER JOIN
                      ReceiveEntryView AS RE ON DTOrder.ItemStoreNo = RE.ItemStoreNo
WHERE     (DTOrder.SortOrder < 6) AND (RE.ReceiveNo = @ReceiveNo)
ORDER BY ItemMainAndStoreView.Name,DTOrder.SortOrder
GO