SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TransferEntryView]
AS
SELECT   DISTINCT     TransferEntry.TransferEntryID, TransferEntry.TransferID, TransferEntry.ItemStoreNo, TransferEntry.Qty, TransferEntry.UOMQty, TransferEntry.UOMPrice, 
                         TransferEntry.LinkNo, TransferEntry.Note, TransferEntry.SortOrder, TransferEntry.Status, TransferEntry.DateCreated, TransferEntry.UserCreated, 
                         TransferEntry.DateModified, TransferEntry.UserModified, M.ItemID, M.Name, M.BarcodeNumber, 
						 M.ModalNumber, S.BinLocation, M.StyleNo, NULL AS ItemAlias, Supp.ItemCode AS  ALU,
						   ISNULL(ReqQty.SumUomQty, 0) AS RequestUOMQty, ISNULL(ReqQty.SumQty, 0) AS RequestQty, 
                         ISNULL(Received.SumUomQty, 0) AS ReciveUOMQty, ISNULL(Received.SumQty, 0) AS ReceiveQty, 
						
                         (CASE WHEN TransferEntry.UOMType = 1 THEN 'DZ' WHEN TransferEntry.UOMType = 2 THEN 'Case' ELSE 'Pc.' END) AS UOM, TransferEntry.UOMType, 
                         ToItemStore.ItemStoreID AS ToItemStoreID, ISNULL(M.CaseQty, 1) AS CaseQty, TransferItems.ToStoreID, TransferItems.FromStoreID, 
                         U.UserName AS UserReceived, (case WHEN ISNULL(TransferEntry.Cost,0) = 0 then S.Cost  else TransferEntry.Cost end) as Cost, 
						 (case WHEN ISNULL(TransferEntry.Cost,0) = 0 then S.Cost  else TransferEntry.Cost end)*Qty As ExtCost,TransferEntry.RequestTransferEntryID,
						 ReqQty.RequestNo,
						 ReqQty.RequestTransferID,
						 TransferItems.TransferStatus
FROM            dbo.TransferEntry WITH (NOLOCK) INNER JOIN
                         dbo.TransferItems WITH (NOLOCK) ON TransferEntry.TransferID = TransferItems.TransferID INNER JOIN
						 dbo.ItemStore AS S WITH (NOLOCK) ON TransferEntry.ItemStoreNo = S.ItemStoreID INNER JOIN 
						 dbo.ItemMain AS M WITH (NOLOCK) ON S.ItemNo = M.ItemID INNER JOIN
                         dbo.ItemStore AS ToItemStore WITH (NOLOCK) ON TransferItems.ToStoreID = ToItemStore.StoreNo AND M.ItemID = ToItemStore.ItemNo LEFT OUTER JOIN
						 dbo.ItemSupply AS Supp WITH (NOLOCK) ON S.ItemStoreID = Supp.ItemStoreNo AND S.MainSupplierID = Supp.ItemSupplyID AND Supp.Status > 0 and Supp.IsMainSupplier = 1 LEFT OUTER JOIN
                             (SELECT        SUM(E.Qty) AS SumQty, SUM(E.UOMQty) AS SumUomQty, MAX(E.UserCreate) AS Usr, E.TransferEntryID
FROM            dbo.ReceiveTransferEntry AS E WITH (NOLOCK) INNER JOIN
                         dbo.ReceiveTransfer AS R ON E.ReceiveTransferID = R.ReceiveTransferID
WHERE        (E.Status > 0) AND (R.Status > 0)
GROUP BY E.TransferEntryID) AS Received ON TransferEntry.TransferEntryID = Received.TransferEntryID	LEFT OUTER JOIN Users AS U ON Received.Usr = U.UserId
							   LEFT OUTER JOIN
                             (SELECT        SUM(Qty) AS SumQty, SUM(UOMQty) AS SumUomQty, RequestTransferEntryID,RequestTransfer.RequestNo,RequestTransferEntry.RequestTransferID
                               FROM            dbo.RequestTransferEntry WITH (NOLOCK) INNER join dbo.RequestTransfer WITH (NOLOCK)  on RequestTransferEntry.RequestTransferID=RequestTransfer.RequestTransferID
                               WHERE        (RequestTransferEntry.Status > 0)
                               GROUP BY RequestTransferEntryID,RequestTransfer.RequestNo,RequestTransferEntry.RequestTransferID) AS ReqQty ON TransferEntry.RequestTransferEntryID = ReqQty.RequestTransferEntryID
GO