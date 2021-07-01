SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[RequestTransferEntryView]
AS





						 
SELECT DISTINCT 
                         RequestTransfer.RequestTransferID, RequestTransferEntry.RequestTransferEntryID, RequestTransfer.RequestNo, RequestTransferEntry.ItemStoreID, FromItemStore.ItemStoreID AS FromItemStoreID, 
                         RequestTransferEntry.UOMType, RequestTransferEntry.Qty, RequestTransferEntry.UOMQty, RequestTransfer.Status, RequestTransfer.Note, RequestTransfer.DateCreated, RequestTransfer.UserCreated, 
                         RequestTransfer.DateModified, RequestTransfer.UserModified, M.ItemID, M.Name, M.BarcodeNumber, M.ModalNumber, 
                         S.BinLocation, M.StyleNo , NULL AS ItemAlias, Supp.ItemCode AS ALU, 
                         (CASE WHEN RequestTransferEntry.UOMType = 1 THEN 'DZ' WHEN RequestTransferEntry.UOMType = 2 THEN 'Case' ELSE 'Pc.' END) AS UOM,  RequestTransfer.FromStoreID, RequestTransfer.ToStoreID, 
                         ISNULL(M.CaseQty, 1) AS CaseQty, (CASE WHEN ISNULL(RequestTransferEntry.Cost, 0) = 0 THEN S.Cost ELSE RequestTransferEntry.Cost END) AS Cost, 
                         M.Matrix1, M.Matrix2, TransferEntrySum.Transfered AS TransferQty, 
                         CASE WHEN RequestTransfer.Status = 2 THEN 0 ELSE (CASE WHEN Requasted > Transfered THEN Requasted - Transfered ELSE 0 END) END AS RequestDeficit,TransferEntrySum.Received AS ReciveUOMQty, 
						 TransferEntrySum.TransferNo,
                         RequestTransferEntry.SortOrder, RequestTransferEntry.CustomerId, CustomerView.CustomerNo, CustomerView.Name AS CustomerName, CustomerView.Cell, RequestTransfer.RequestDate
FROM            dbo.RequestTransfer INNER JOIN
                         dbo.RequestTransferEntry ON RequestTransfer.RequestTransferID = RequestTransferEntry.RequestTransferID	INNER JOIN
						 dbo.ItemStore AS FromItemStore WITH (NOLOCK) ON RequestTransfer.FromStoreID = FromItemStore.StoreNo AND RequestTransferEntry.ItemID = FromItemStore.ItemNo INNER JOIN
						 dbo.ItemStore AS S WITH (NOLOCK) ON FromItemStore.ItemStoreID = S.ItemStoreID INNER JOIN 
						 dbo.ItemMain AS M WITH (NOLOCK) ON S.ItemNo = M.ItemID LEFT OUTER JOIN
						 dbo.ItemSupply AS Supp WITH (NOLOCK) ON S.ItemStoreID = Supp.ItemStoreNo AND S.MainSupplierID = Supp.ItemSupplyID AND Supp.Status > 0 and Supp.IsMainSupplier = 1 LEFT OUTER JOIN
                             (SELECT DISTINCT 
                                                         RequestTransferEntry.RequestTransferEntryID, ISNULL(RequestTransferEntry.UOMQty, 0) AS Requasted, SUM(ISNULL(Transfered.QtyTransfer, 0)) AS Transfered, SUM(ISNULL(Transfered.QtyReceive, 0)) 
                                                         AS Received,
														 Transfered.TransferNo
                               FROM            RequestTransferEntry INNER JOIN
                                                         RequestTransfer ON RequestTransferEntry.RequestTransferID = RequestTransfer.RequestTransferID LEFT OUTER JOIN
                                                             (SELECT     DISTINCT   t1.RequestTransferEntryID, 
															   STUFF((SELECT distinct   ',' + t3.TransferNo 
         from TransferEntry t2 , TransferItems t3 
         where t1.RequestTransferEntryID = t2.RequestTransferEntryID
		 and t2.TransferID=t3.TransferID	AND t2.Status > 0 and t3.Status > 0
            FOR XML PATH(''), TYPE
            ).value('.', 'VARCHAR(MAX)') 
        ,1,1,'') TransferNo,
															 SUM(ISNULL(t1.UOMQty, 0)) AS QtyTransfer, SUM(ISNULL(ReceiveTransferEntry.Qty, 0)) AS QtyReceive
                                                               FROM            TransferItems  INNER JOIN
                                                                                         TransferEntry t1 ON TransferItems.TransferID = t1.TransferID AND t1.Status > 0 AND TransferItems.Status > 0 LEFT OUTER JOIN
                                                                                             (SELECT        TransferEntryID, SUM(UOMQty) AS Qty
                                                                                               FROM            ReceiveTransferEntry
                                                                                               WHERE        (Status > 0)
                                                                                               GROUP BY TransferEntryID) AS ReceiveTransferEntry ON t1.TransferEntryID = ReceiveTransferEntry.TransferEntryID
																							   WHERE t1.RequestTransferEntryID IS NOT NULL
                                                               GROUP BY t1.RequestTransferEntryID,TransferItems.TransferNo) AS Transfered ON RequestTransferEntry.RequestTransferEntryID = Transfered.RequestTransferEntryID
															   GROUP BY RequestTransferEntry.RequestTransferEntryID, RequestTransferEntry.UOMQty,Transfered.TransferNo) AS TransferEntrySum ON 
                         TransferEntrySum.RequestTransferEntryID = RequestTransferEntry.RequestTransferEntryID LEFT OUTER JOIN
                         CustomerView ON RequestTransferEntry.CustomerId = CustomerView.CustomerID
WHERE        (1 = 1) AND (RequestTransferEntry.Status >= 0)
GO