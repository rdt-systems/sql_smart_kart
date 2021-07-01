SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_TransactionAvrg]
(@Filter nvarchar(4000))
AS
DECLARE @MySelect nvarchar(4000)
DECLARE @MyGroup nvarchar(4000)

SET @MySelect ='SELECT   Store.StoreName, COUNT(DISTINCT TransactionEntryItem.TransactionID) AS NoTrans, SUM(TransactionEntryItem.QTY) AS UOMQty, SUM(TransactionEntryItem.Total) AS Total, 
                         dbo.getDay(TransactionEntryItem.StartSaleTime)As SaleDay,
						  (CASE WHEN(isnull(COUNT(TransactionEntryItem.TransactionID),1)>0 AND isnull(SUM(TransactionEntryItem.QTY),0)>0) THEN 
						           (isnull(SUM(TransactionEntryItem.QTY),0)/isnull(COUNT(TransactionEntryItem.TransactionID),1) )ELSE 0 END) AS TransUnit,
			            (CASE WHEN(isnull(COUNT(TransactionEntryItem.TransactionID),1)>0 AND isnull(SUM(TransactionEntryItem.Total),0)>0) THEN 
						           ( isnull(SUM(TransactionEntryItem.Total),0)/isnull(COUNT(TransactionEntryItem.TransactionID),1) )ELSE 0 END) AS TransSale, 
								   ShoperTrack.pplCount
FROM            TransactionEntryItem INNER JOIN
                         Store ON TransactionEntryItem.StoreID = Store.StoreID '

--SET @MyGroup ='LEFT OUTER JOIN ShopperTrack ON dbo.GetDay(TransactionEntryItem.StartSaleTime) = dbo.GetDay(ShopperTrack.stime) GROUP BY Store.StoreName, dbo.getDay(TransactionEntryItem.StartSaleTime)'
SET @MyGroup =' LEFT OUTER JOIN
                          (SELECT     dbo.GetDay(DateCreated) AS ShoperDay, SUM(enters) AS pplCount, StoreNo
                            FROM          ShopperTrack
                            GROUP BY dbo.GetDay(DateCreated), StoreNo) AS ShoperTrack ON Store.StoreNumber = ShoperTrack.StoreNo AND 
                      dbo.GetDay(TransactionEntryItem.StartSaleTime) = ShoperTrack.ShoperDay
GROUP BY Store.StoreName, dbo.GetDay(TransactionEntryItem.StartSaleTime), ShoperTrack.pplCount'

print (@MySelect + @Filter +@MyGroup )
Execute (@MySelect + @Filter +@MyGroup )
GO