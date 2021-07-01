SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetSalesByStore](@Date datetime = NULL)
AS
IF @Date IS NULL 
Set @Date = dbo.GetDay(dbo.GetLocalDATE() -1)

SELECT        Parent.Name, ITM.Matrix1, ITM.Matrix2, SUM(ISNULL(Willi.Qty, 0)) AS [Qty Sold In Williamsburg], SUM(ISNULL(KJ.Qty, 0)) AS [Qty Sold In KJ], SUM(ISNULL(OffCasual.Qty, 0)) AS [Qty Sold In Off Casual]
FROM            ItemMain AS ITM INNER JOIN
                             (SELECT        Name, ItemID
                               FROM            ItemMain
                               WHERE        (ItemType = 2)) AS Parent ON ITM.LinkNo = Parent.ItemID INNER JOIN
                         ItemStore AS ITS ON ITM.ItemID = ITS.ItemNo LEFT OUTER JOIN
                             (SELECT        TE.ItemStoreID, T.StoreID, SUM(TE.Qty) AS Qty
                               FROM            [Transaction] AS T INNER JOIN
                                                         TransactionEntry AS TE ON T.TransactionID = TE.TransactionID
                               WHERE        (T.Status > 0) AND (TE.Status > 0) AND (T.StartSaleTime >= @Date) AND (T.StartSaleTime < @Date + 1) AND (T.StoreID = '0E25FF59-7509-4FA0-AD07-5275720233E6')
                               GROUP BY T.StoreID, TE.ItemStoreID) AS OffCasual ON ITS.ItemStoreID = OffCasual.ItemStoreID LEFT OUTER JOIN
                             (SELECT        TE.ItemStoreID, T.StoreID, SUM(TE.Qty) AS Qty
                               FROM            [Transaction] AS T INNER JOIN
                                                         TransactionEntry AS TE ON T.TransactionID = TE.TransactionID
                               WHERE        (T.Status > 0) AND (TE.Status > 0) AND (T.StartSaleTime >= @Date) AND (T.StartSaleTime < @Date + 1) AND (T.StoreID = '9F5C05D4-A9E5-478F-91A9-F47E27433D04')
                               GROUP BY T.StoreID, TE.ItemStoreID) AS KJ ON ITS.ItemStoreID = KJ.ItemStoreID LEFT OUTER JOIN
                             (SELECT        TE.ItemStoreID, T.StoreID, SUM(TE.Qty) AS Qty
                               FROM            [Transaction] AS T INNER JOIN
                                                         TransactionEntry AS TE ON T.TransactionID = TE.TransactionID
                               WHERE        (T.Status > 0) AND (TE.Status > 0) AND (T.StartSaleTime >= @Date) AND (T.StartSaleTime < @Date + 1) AND (T.StoreID = 'BDDF302F-E9D3-4C97-8D3D-A4A366D591F1')
                               GROUP BY T.StoreID, TE.ItemStoreID) AS Willi ON ITS.ItemStoreID = Willi.ItemStoreID
WHERE        (Willi.Qty IS NOT NULL) OR
                         (KJ.Qty IS NOT NULL) OR
                         (OffCasual.Qty IS NOT NULL)
GROUP BY Parent.Name, ITM.Matrix1, ITM.Matrix2
ORDER BY Parent.Name, ITM.Matrix1, ITM.Matrix2
GO