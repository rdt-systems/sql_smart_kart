SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[FnGetItemOnhand](@ToDate datetime)
RETURNS  table
--Dashboard should load faster 
--8 Dec 2017, Raju Khadgi
--@rtnTable TABLE (ItemStoreID uniqueidentifier, Qty decimal) 
AS
return(
--BEGIN

--declare @UpToDate datetime
--SET @UpToDate =  
----DECLARE @TempTable table (id uniqueidentifier, Qty decimal)

--insert into @rtnTable 
SELECT       ItemStore.ItemNo AS ItemID, ItemStore.ItemStoreID, ISNULL(Recive.Qty, 0) - ISNULL(Trans.Qty, 0) + ISNULL(ReceiveTransfer.Qty, 0) - ISNULL(ReturnToVendore.Qty, 0) - ISNULL(Transfer.Qty, 0) 
                         + ISNULL(Adjust.Qty, 0) AS Qty
FROM            ItemStore LEFT OUTER JOIN
                             (SELECT        SUM(Qty) AS Qty, ItemStoreID
                               FROM            ReceiveTransferEntry
                               WHERE        (DateCREATE <= DATEADD(day,1,@ToDate)) AND (Status > 0)
                               GROUP BY ItemStoreID) AS ReceiveTransfer ON ItemStore.ItemStoreID = ReceiveTransfer.ItemStoreID LEFT OUTER JOIN
                             (SELECT        SUM(Qty) AS Qty, ItemStoreNo
                               FROM            AdjustInventory
                               WHERE        (DateCreated < DATEADD(day,1,@ToDate)) AND (Status > 0)
                               GROUP BY ItemStoreNo) AS Adjust ON ItemStore.ItemStoreID = Adjust.ItemStoreNo LEFT OUTER JOIN
                             (SELECT        SUM(TransferEntry.Qty) AS Qty, TransferEntry.ItemStoreNo
                               FROM            TransferEntry INNER JOIN
                                                         TransferItems ON TransferItems.TransferID = TransferEntry.TransferID
                               WHERE        (TransferEntry.Status > 0) AND (TransferItems.TransferDate <= dbo.GetLocalDATE()) AND (TransferItems.Status > 0)
                               GROUP BY TransferEntry.ItemStoreNo) AS Transfer ON ItemStore.ItemStoreID = Transfer.ItemStoreNo LEFT OUTER JOIN
                             (SELECT        SUM(ISNULL(ReturnToVenderEntry.Qty, 0)) AS Qty, ReturnToVenderEntry.ItemStoreNo
                               FROM            ReturnToVenderEntry INNER JOIN
                                                         ReturnToVender ON ReturnToVenderEntry.ReturnToVenderID = ReturnToVender.ReturnToVenderID
                               WHERE        (ReturnToVenderEntry.Status > 0) AND (ReturnToVender.ReturnToVenderDate < DATEADD(day,1,@ToDate)) AND (ReturnToVender.Status > 0)
                               GROUP BY ReturnToVenderEntry.ItemStoreNo) AS ReturnToVendore ON ItemStore.ItemStoreID = ReturnToVendore.ItemStoreNo LEFT OUTER JOIN
                             (SELECT        SUM(TransactionEntry.Qty) AS Qty, TransactionEntry.ItemStoreID
                               FROM            TransactionEntry INNER JOIN
                                                         [Transaction] ON TransactionEntry.TransactionID = [Transaction].TransactionID
                               WHERE        (TransactionEntry.Status > 0) AND ([Transaction].StartSaleTime < DATEADD(day,1,@ToDate)) AND ([Transaction].Status > 0)
                               GROUP BY TransactionEntry.ItemStoreID) AS Trans ON ItemStore.ItemStoreID = Trans.ItemStoreID LEFT OUTER JOIN
                             (SELECT        SUM(ReceiveEntry.Qty) AS Qty, ReceiveEntry.ItemStoreNo
                               FROM            ReceiveEntry INNER JOIN
                                                         ReceiveOrderView ON ReceiveEntry.ReceiveNo = ReceiveOrderView.ReceiveID
                               WHERE        (ReceiveEntry.Status > 0) AND (ReceiveOrderView.ReceiveOrderDate < DATEADD(day,1,@ToDate)) AND (ReceiveOrderView.Status > 0)
                               GROUP BY ReceiveEntry.ItemStoreNo) AS Recive ON ItemStore.ItemStoreID = Recive.ItemStoreNo

--insert Into @rtnTable 
--SELECT * FROM @TempTable 

--END
)
GO