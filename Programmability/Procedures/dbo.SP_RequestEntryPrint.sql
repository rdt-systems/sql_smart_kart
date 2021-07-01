SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_RequestEntryPrint](@ID uniqueidentifier, 
@MySort nvarchar(100) = NULL)
AS 

IF ISNULL(@MySort,'') = ''
SET @MySort = 'BarcodeNumber'

Declare @MySelect nvarchar(4000)
SET @MySelect = 'SELECT        ItemMainAndStoreGrid.BarcodeNumber, ItemMainAndStoreGrid.Name, RequestTransferEntry.UOMQty, RequestTransferEntry.RequestTransferID, RequestTransferEntry.UOMType, SysUOMTypeView.SystemValueName AS UOM, 
                         RequestTransferEntry.RequestTransferEntryID, ItemMainAndStoreGrid.ModalNumber, ItemMainAndStoreGrid.BinLocation, ItemMainAndStoreGrid.[Supplier Item Code] AS ALU, ItemMainAndStoreGrid.ItemAlias, 
                         RequestTransferEntry.SortOrder, CONVERT(Decimal, ItemMainAndStoreGrid.OnHand) AS OnHand, (CASE WHEN ISNULL(RequestTransferEntry.Cost, 0) = 0 THEN ItemMainAndStoreGrid.Cost ELSE RequestTransferEntry.Cost END)
                          AS Cost, RequestTransferEntry.Note, ISNULL(T.UOMQty,0) AS QtyShipped
FROM            ItemMainAndStoreView AS ItemMainAndStoreGrid INNER JOIN
                         RequestTransferEntry ON ItemMainAndStoreGrid.ItemStoreID = RequestTransferEntry.ItemStoreID INNER JOIN
                         SysUOMTypeView ON SysUOMTypeView.SystemValueNo = RequestTransferEntry.UOMType LEFT OUTER JOIN
                             (SELECT        TransferEntry.RequestTransferEntryID, TransferEntry.UOMQty
                               FROM            TransferEntry INNER JOIN
                                                         TransferItems ON TransferEntry.TransferID = TransferItems.TransferID
                               WHERE        (TransferItems.Status > 0) AND (TransferEntry.Status > 0)) AS T ON RequestTransferEntry.RequestTransferEntryID = T.RequestTransferEntryID
WHERE        (RequestTransferEntry.RequestTransferID = ''' + CONVERT(nvarchar(50),@ID) + ''') AND (RequestTransferEntry.Status > 0)
ORDER BY '


Print (@MySelect + @MySort)
Execute (@MySelect + @MySort)
GO