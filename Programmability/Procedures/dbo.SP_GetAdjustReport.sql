SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_GetAdjustReport] 
	(@AdjustDate datetime
)

AS

SELECT   I.StoreName,     I.Department, I.ModalNumber, I.BarcodeNumber AS UPC, I.Name, I.Size, I.Matrix1 AS Color, I.Matrix2 AS Sizze, I.CaseQty, I.[Pc Cost], CAST(A.OldQty AS int) AS OldOnHand, CAST(A.Qty AS int) AS AddedQty, A.Cost, CAST(A.OldQty + A.Qty AS int) AS NewOnHand,
CAST(A.OldQty * I.[Pc Cost] AS money) AS PreviousExtCost,CAST((A.OldQty + A.Qty) * I.[Pc Cost] AS Money) AS NewExtCost, CAST(A.Qty * I.[Pc Cost] AS money) 
                         AS ValueAdded
FROM            AdjustInventory AS A INNER JOIN
                         ItemMainAndStoreGrid AS I ON A.ItemStoreNo = I.ItemStoreID
WHERE        (A.Status > 0) AND (CAST(A.DateCreated AS date) = @AdjustDate) AND (A.Qty <> 0)
GO