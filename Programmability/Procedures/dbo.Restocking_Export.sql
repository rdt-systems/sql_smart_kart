SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Restocking_Export]
AS
SELECT       Pastel.Department, M.ModalNumber AS SKU, M.Name, M.Matrix1 AS Color, M.Matrix2 AS Size, Pastel.[7] + W.[7] + BP.[7] + Lkwd.[7] + KJ.[7] + Monsey.[7] + RC.[7] AS [Total7], 
                         Pastel.[14] + W.[14] + BP.[14] + Lkwd.[14] + KJ.[14] + Monsey.[14] + RC.[14] AS [Total14], Pastel.OnHand AS Pastel, Pastel.[7] AS Pastel7, Pastel.[14] AS Pastel14, W.OnHand AS Willi, W.[7] AS Willi7, W.[14] AS Willi14, 
                         BP.OnHand AS BP, BP.[7] AS BP7, BP.[14] AS BP14, Lkwd.OnHand AS Lkwd, Lkwd.[7] AS Lkwd7, Lkwd.[14] AS Lkwd14, KJ.OnHand AS KJ, KJ.[7] AS KJ7, KJ.[14] AS KJ14, Monsey.OnHand AS Monsey, Monsey.[7] AS Monsey7, 
                         Monsey.[14] AS Monsey14, RC.OnHand AS Receiving, RC.[7] AS Rec7, RC.[14] AS Rec14
FROM            ItemMain AS M INNER JOIN
                             (SELECT       D.Name AS Department, S.ItemNo AS ItemID, CAST(ISNULL(S.OnHand,0) AS INT) AS OnHand, CAST(ISNULL(Seven.Sold, 0) AS INT) AS [7], CAST(ISNULL(Fourtin.Sold, 0) AS INT) AS [14]
                               FROM            ItemStore AS S LEFT OUTER JOIN DepartmentStore AS D ON S.DepartmentID = D.DepartmentStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 7 AS date))
                                                               GROUP BY ItemStoreID) AS Seven ON S.ItemStoreID = Seven.ItemStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 14 AS date))
                                                               GROUP BY ItemStoreID) AS Fourtin ON S.ItemStoreID = Fourtin.ItemStoreID
                               WHERE        (S.StoreNo = '46C8541B-33D4-4A73-AA82-9520DF098D44')) AS Pastel ON M.ItemID = Pastel.ItemID INNER JOIN
                             (SELECT        S.ItemNo AS ItemID, CAST(ISNULL(S.OnHand,0) AS INT) AS OnHand, CAST(ISNULL(Seven.Sold, 0) AS INT) AS [7], CAST(ISNULL(Fourtin.Sold, 0) AS INT) AS [14]
                               FROM            ItemStore AS S LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 7 AS date))
                                                               GROUP BY ItemStoreID) AS Seven ON S.ItemStoreID = Seven.ItemStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 14 AS date))
                                                               GROUP BY ItemStoreID) AS Fourtin ON S.ItemStoreID = Fourtin.ItemStoreID
                               WHERE        (S.StoreNo = '8C176A9C-1CAC-46F6-BD9D-663B5CCB63C6')) AS W ON M.ItemID = W.ItemID INNER JOIN
                             (SELECT        S.ItemNo AS ItemID, CAST(ISNULL(S.OnHand,0) AS INT) AS OnHand, CAST(ISNULL(Seven.Sold, 0) AS INT) AS [7], CAST(ISNULL(Fourtin.Sold, 0) AS INT) AS [14]
                               FROM            ItemStore AS S LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 7 AS date))
                                                               GROUP BY ItemStoreID) AS Seven ON S.ItemStoreID = Seven.ItemStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 14 AS date))
                                                               GROUP BY ItemStoreID) AS Fourtin ON S.ItemStoreID = Fourtin.ItemStoreID
                               WHERE        (S.StoreNo = 'AE6BE9B1-4350-42F7-9DA2-7502C67DAF04')) AS KJ ON M.ItemID = KJ.ItemID INNER JOIN
                             (SELECT        S.ItemNo AS ItemID, CAST(ISNULL(S.OnHand,0) AS INT) AS OnHand, CAST(ISNULL(Seven.Sold, 0) AS INT) AS [7], CAST(ISNULL(Fourtin.Sold, 0) AS INT) AS [14]
                               FROM            ItemStore AS S LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 7 AS date))
                                                               GROUP BY ItemStoreID) AS Seven ON S.ItemStoreID = Seven.ItemStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 14 AS date))
                                                               GROUP BY ItemStoreID) AS Fourtin ON S.ItemStoreID = Fourtin.ItemStoreID
                               WHERE        (S.StoreNo = '78418963-8A73-443D-9E9E-68D082AF9D96')) AS BP ON M.ItemID = BP.ItemID INNER JOIN
                             (SELECT        S.ItemNo AS ItemID, CAST(ISNULL(S.OnHand,0) AS INT) AS OnHand, CAST(ISNULL(Seven.Sold, 0) AS INT) AS [7], CAST(ISNULL(Fourtin.Sold, 0) AS INT) AS [14]
                               FROM            ItemStore AS S LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 7 AS date))
                                                               GROUP BY ItemStoreID) AS Seven ON S.ItemStoreID = Seven.ItemStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 14 AS date))
                                                               GROUP BY ItemStoreID) AS Fourtin ON S.ItemStoreID = Fourtin.ItemStoreID
                               WHERE        (S.StoreNo = 'B08DEE4A-AE31-49B0-8670-F6845D20E6F4')) AS Lkwd ON M.ItemID = Lkwd.ItemID INNER JOIN
                             (SELECT        S.ItemNo AS ItemID, CAST(ISNULL(S.OnHand,0) AS INT) AS OnHand, CAST(ISNULL(Seven.Sold, 0) AS INT) AS [7], CAST(ISNULL(Fourtin.Sold, 0) AS INT) AS [14]
                               FROM            ItemStore AS S LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 7 AS date))
                                                               GROUP BY ItemStoreID) AS Seven ON S.ItemStoreID = Seven.ItemStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 14 AS date))
                                                               GROUP BY ItemStoreID) AS Fourtin ON S.ItemStoreID = Fourtin.ItemStoreID
                               WHERE        (S.StoreNo = '326641DD-A035-449C-AEC7-01D90625B712')) AS Monsey ON M.ItemID = Monsey.ItemID INNER JOIN
                             (SELECT        S.ItemNo AS ItemID, CAST(ISNULL(S.OnHand,0) AS INT) AS OnHand, CAST(ISNULL(Seven.Sold, 0) AS INT) AS [7], CAST(ISNULL(Fourtin.Sold, 0) AS INT) AS [14]
                               FROM            ItemStore AS S LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 7 AS date))
                                                               GROUP BY ItemStoreID) AS Seven ON S.ItemStoreID = Seven.ItemStoreID LEFT OUTER JOIN
                                                             (SELECT        ItemStoreID, SUM(QTY) AS Sold
                                                               FROM            TransactionEntryItem
                                                               WHERE        (EndSaleTime >= CAST(dbo.GetLocalDate() - 14 AS date))
                                                               GROUP BY ItemStoreID) AS Fourtin ON S.ItemStoreID = Fourtin.ItemStoreID
                               WHERE        (S.StoreNo = '0B4C28E6-80D5-42F3-B7D7-1E01DC1BE037')) AS RC ON M.ItemID = RC.ItemID
WHERE        (M.ItemType <> 2)
GO