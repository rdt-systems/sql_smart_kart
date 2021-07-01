SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RPT_ReceivedItemsStatus]
(@FromDate datetime,
@ToDate DATETIME,
@StoreID UNIQUEIDENTIFIER =null
)
AS
SELECT DISTINCT
       ISNULL(D.Name, '') AS Department,
       Sson.Season,
       M.ModalNumber,
       M.BarcodeNumber,
       M.Name,
       M.Matrix1 AS Color,
       M.Matrix2 AS Size,
       S.Cost,
       S.Price,
       ISNULL(R.Received, 0) AS Received,
       ISNULL(L.Sold, 0) AS Sold,
       SUM(S.OnHand) AS OnHand
FROM dbo.ItemMain M WITH (NOLOCK)
    INNER JOIN dbo.ItemStore S WITH (NOLOCK)
        ON M.ItemID = S.ItemNo
    LEFT OUTER JOIN dbo.DepartmentStore AS D
        ON S.DepartmentID = D.DepartmentStoreID
    LEFT OUTER JOIN
    (
        SELECT DISTINCT
               S.ItemNo AS ItemID,
               G.ItemGroupName AS Season
        FROM dbo.ItemGroup G WITH (NOLOCK)
            INNER JOIN dbo.ItemToGroup GG WITH (NOLOCK)
                ON G.ItemGroupID = GG.ItemGroupID
            INNER JOIN dbo.ItemStore S WITH (NOLOCK)
                ON GG.ItemStoreID = S.ItemStoreID
        WHERE G.Status > 0
              AND GG.Status > 0
              AND S.Status > 0
    ) AS Sson
        ON M.ItemID = Sson.ItemID
    LEFT OUTER JOIN
    (
        SELECT I.ItemNo AS ItemID,
               SUM(ISNULL(E.Qty, 0)) AS Received
        FROM dbo.ReceiveEntry E WITH (NOLOCK)
            INNER JOIN dbo.ReceiveOrder O WITH (NOLOCK)
                ON E.ReceiveNo = O.ReceiveID
            INNER JOIN dbo.ItemStore I WITH (NOLOCK)
                ON E.ItemStoreNo = I.ItemStoreID
			INNER JOIN dbo.Bill ON Bill.BillID = O.BillID
        WHERE E.Status > 0
              AND O.Status > 0
              AND I.Status > 0
			  AND (I.StoreNo=@StoreID OR @StoreID IS NULL) 
        GROUP BY I.ItemNo
    ) AS R
        ON M.ItemID = R.ItemID
    LEFT OUTER JOIN
    (
        SELECT ItemID,
               SUM(QTY) AS Sold
        FROM dbo.TransactionEntryItem AS L
        WHERE L.EndSaleTime >= @FromDate
              AND L.EndSaleTime < @ToDate
			  AND (L.StoreID=@StoreID OR @StoreID IS NULL) 
        GROUP BY L.ItemID
    ) AS L
        ON M.ItemID = L.ItemID
WHERE M.Status > 0
      AND S.Status > 0
	  AND (S.StoreNo=@StoreID OR @StoreID IS NULL) 
GROUP BY ISNULL(D.Name, ''),
         Sson.Season,
         M.ModalNumber,
         M.BarcodeNumber,
         M.Name,
         M.Matrix1,
         M.Matrix2,
         S.Cost,
         S.Price,
         ISNULL(R.Received, 0),
         ISNULL(L.Sold, 0);
GO