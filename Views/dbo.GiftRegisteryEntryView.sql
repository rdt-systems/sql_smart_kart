SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[GiftRegisteryEntryView]
AS
SELECT        ItemMain.Name AS ItemName, ItemMain.ModalNumber AS ModalNo, ItemMain.BarcodeNumber AS UPC, GiftRegisteryEntry.QtyRequested, 
                         GiftRegisteryEntry.GiftRegisteryID, ISNULL(Received.Qty, 0) AS QtyReceived, GiftRegisteryEntry.ItemID, GiftRegisteryEntry.GiftRegisteryEntryID, 
                         GiftRegisteryEntry.Status, Received.Price
FROM            GiftRegisteryEntry INNER JOIN
                         ItemMain ON GiftRegisteryEntry.ItemID = ItemMain.ItemID LEFT OUTER JOIN
                             (SELECT        [Transaction].Status, SUM(TransactionEntry.Qty) AS Qty, TransEntryToRegEntry.RegEntryID, TEI.Price As Price
                               FROM            [Transaction] INNER JOIN
                                                         TransactionEntry ON [Transaction].TransactionID = TransactionEntry.TransactionID RIGHT OUTER JOIN
                                                         TransEntryToRegEntry ON TransactionEntry.TransactionEntryID = TransEntryToRegEntry.TransEntryID
														 join TransactionEntryItem TEI ON TEI.TransactionEntryID = TransactionEntry.TransactionEntryID
                               WHERE        (TransEntryToRegEntry.Status > 0) AND (TransactionEntry.Status > 0)
                               GROUP BY [Transaction].Status, TransEntryToRegEntry.RegEntryID, Price
                               HAVING         ([Transaction].Status > 0)) AS Received ON GiftRegisteryEntry.GiftRegisteryEntryID = Received.RegEntryID
WHERE        (GiftRegisteryEntry.Status > 0)
GO