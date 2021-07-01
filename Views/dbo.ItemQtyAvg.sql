SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[ItemQtyAvg]
AS
SELECT     itemid, (CASE WHEN (DATEDIFF(week, DateCreated, dbo.GetLocalDATE())) = 0 THEN NULL ELSE DATEDIFF(week, DateCreated, dbo.GetLocalDATE()) END) AS WeekB, 
                      (CASE WHEN (DATEDIFF(month, DateCreated, dbo.GetLocalDATE())) = 0 THEN NULL ELSE DATEDIFF(month, DateCreated, dbo.GetLocalDATE()) END) AS MonthB, 
                      (CASE WHEN (DATEDIFF(year, DateCreated, dbo.GetLocalDATE())) = 0 THEN NULL ELSE DATEDIFF(year, DateCreated, dbo.GetLocalDATE()) END) AS YearB, 
                      TotalQty
FROM         dbo.[ItemQty]
GO