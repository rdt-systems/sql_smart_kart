SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetEntryProfit]
(@TransactionID uniqueidentifier)
as


--SELECT     [Name], UOMPrice, UOMQty, Total, (AvgCost*Isnull(Qty,0)) as Cost, CASE WHEN Total <>0 THEN (DiscountOnTotal/(Total/100))/100 ELSE 0 END As DiscountPerc, DiscountOnTotal AS DiscountAmount, 
--			Total-IsNull(DiscountOnTotal,0) AS TotalAfterDiscount,
--			CASE WHEN ((Total-DiscountOnTotal)<>0)AND (AvgCost*Isnull(Qty,0))<>0  THEN ((Total-DiscountOnTotal) - (AvgCost*Isnull(Qty,0))) / (AvgCost*Isnull(Qty,0)) ELSE 0 END
--	        AS Markup,
--			CASE WHEN ((Total-DiscountOnTotal)<>0)AND (AvgCost*Isnull(Qty,0))<>0  THEN ((Total-DiscountOnTotal) -  (AvgCost*Isnull(Qty,0))) / (Total-DiscountOnTotal) ELSE 0 END AS Margin, 
--			(Total -DiscountOnTotal)-(AvgCost*Isnull(Qty,0)) AS Profit,DiscountOnTotal
--FROM         dbo.TransactionEntryView
SELECT     RegUnitPrice,[Name], UOMPrice, UOMQty, Total, (AvgCost*Isnull(Qty,0)) as Cost, CASE WHEN Total <>0 THEN (100-((TotalAfterDiscount/Total)*100))/100 ELSE 0 END As DiscountPerc, Total-TotalAfterDiscount AS DiscountAmount, 
			 TotalAfterDiscount,
			CASE WHEN ((Total-DiscountOnTotal)<>0)AND (AvgCost*Isnull(Qty,0))<>0  THEN ((Total-DiscountOnTotal) - (AvgCost*Isnull(Qty,0))) / (AvgCost*Isnull(Qty,0)) ELSE 0 END
	        AS Markup,
			CASE WHEN ((Total-DiscountOnTotal)<>0)AND (AvgCost*Isnull(Qty,0))<>0  THEN ((Total-DiscountOnTotal) -  (AvgCost*Isnull(Qty,0))) / (Total-DiscountOnTotal) ELSE 0 END AS Margin, 
			(Total -DiscountOnTotal)-(AvgCost*Isnull(Qty,0)) AS Profit,DiscountOnTotal
FROM         dbo.TransactionEntryView
WHERE  Status>0 and TransactionID=@TransactionID And TransactionEntryType<>4 --And TransactionEntryType=0
GO