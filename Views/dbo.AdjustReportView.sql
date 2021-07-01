SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[AdjustReportView]

AS

SELECT        I.Department, I.Brand, I.Groups, I.BarcodeNumber, I.ModalNumber, I.Name, I.CaseQty, I.Matrix1, I.Matrix2, I.Size, I.StoreNo AS StoreID, I.StoreName, V.SystemValueNo AS AdjustType, CAST(A.DateCreated AS time) AS Time, 
                         CAST(A.DateCreated AS date) AS Date, A.AdjustReason, CASE WHEN ISNULL(A.Cost, 0) = 0 THEN I.[Pc Cost] ELSE A.Cost END AS PcCost, A.OldQty,  (A.OldQty + A.Qty) AS NewQty, A.Qty as Diff, I.OnHand AS CurrentOnHand, 
                         I.[Pc Cost] * I.OnHand AS CurrentTotalValue, A.Qty * CASE WHEN ISNULL(A.Cost, 0) = 0 THEN I.[Pc Cost] ELSE A.Cost END AS ValueDiff, 
                         U.UserName
FROM            AdjustInventory AS A INNER JOIN
                         ItemMainAndStoreGrid AS I ON A.ItemStoreNo = I.ItemStoreID INNER JOIN
                         Users AS U ON A.UserCreated = U.UserId INNER JOIN
                             (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 6)) AS V ON A.AdjustType = V.SystemValueNo
WHERE        (A.Status > 0) AND (A.OldQty <> A.Qty)



GO