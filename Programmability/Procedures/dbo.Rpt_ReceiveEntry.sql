SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_ReceiveEntry] 
(@ReceiveNo uniqueidentifier )
AS
SELECT  
imsv.Name,   
imsv.BarcodeNumber, 
imsv.Price, 
imsv.Size,
re.Qty as 'QTY',
CONVERT(varchar(50), 
	re.CaseCost)
+' / '+
CONVERT(varchar(50),
	CASE WHEN ISNULL(re.CaseCost,0)>0 THEN
		CASE WHEN ISNULL(Imsv.CaseQty,1)>0 THEN
			(re.CaseCost/Imsv.CaseQty)		 
		ELSE
			re.CaseCost
		END
	ELSE
		0
	END) AS 'Cost',
imsv.CaseQty As 'CaseQty',
CONVERT(varchar(50), 
	(CASE WHEN ISNULL(imsv.Price,0)> 0 THEN 
		CASE WHEN ISNULL(re.CaseCost,0)>0 THEN
			(imsv.Price*IsNull(Imsv.CaseQty,0) - re.CaseCost)/re.CaseCost
		ELSE
			0
		END
	ELSE
		0
	END)*100)
+' / '+
CONVERT(varchar(50), 
	(CASE WHEN ISNULL(imsv.Price,0)> 0 THEN 
		CASE WHEN ISNULL(re.CaseCost,0)>0 THEN
			CASE WHEN ISNULL(Imsv.CaseQty,1)>0 THEN
				((imsv.Price*IsNull(Imsv.CaseQty,0)) - re.CaseCost)/(imsv.Price * IsNull(Imsv.CaseQty,1))
			ELSE
				((imsv.Price*1) - re.CaseCost)/(imsv.Price * 1)
			END
		ELSE
			0
		END
	ELSE
		0
	END)*100) AS 'MarkupMARGIN'

FROM         ReceiveEntry AS re INNER JOIN
                      ItemMainAndStoreView AS imsv ON re.ItemStoreNo = imsv.ItemStoreID
WHERE     (re.Status > 0) AND (re.ReceiveNo = @ReceiveNo)
ORDER BY re.SortOrder
GO