SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetGrossProfit]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     TransactionEntryView.[Name], UOMPrice, UOMQty, Total, (TransactionEntryView.AvgCost*Isnull(Qty,0)) as Cost, CASE WHEN Total <>0 THEN (DiscountOnTotal/(Total/100))/100 ELSE 0 END As DiscountPerc, DiscountOnTotal AS DiscountAmount, 
			Total-IsNull(DiscountOnTotal,0) AS TotalAfterDiscount,
			CASE WHEN ((Total-DiscountOnTotal)<>0)AND (TransactionEntryView.AvgCost*Isnull(Qty,0))<>0  THEN ((Total-DiscountOnTotal) - (TransactionEntryView.AvgCost*Isnull(Qty,0))) / (TransactionEntryView.AvgCost*Isnull(Qty,0)) ELSE 0 END
	        AS Markup,
			CASE WHEN ((Total-DiscountOnTotal)<>0)AND (TransactionEntryView.AvgCost*Isnull(Qty,0))<>0  THEN ((Total-DiscountOnTotal) -  (TransactionEntryView.AvgCost*Isnull(Qty,0))) / (Total-DiscountOnTotal) ELSE 0 END AS Margin, 
			(Total -DiscountOnTotal)-(TransactionEntryView.AvgCost*Isnull(Qty,0)) AS Profit,DiscountOnTotal,TransactionEntryView.DateCreated , SupplierName ,SeasonName,itemmainandstoreview.MainDepartment,itemmainandstoreview.SubDepartment,itemmainandstoreview.SubSubDepartment,itemmainandstoreview.OnHand,TransactionNo
FROM         dbo.TransactionEntryView inner join itemmainandstoreview on TransactionEntryView.ItemStoreID =itemmainandstoreview.ItemStoreID join  [Transaction] on   [Transaction].TransactionID =TransactionEntryView.TransactionID
WHERE  TransactionEntryView.Status>0  And TransactionEntryType<>4'
Execute (@MySelect + @Filter )
GO