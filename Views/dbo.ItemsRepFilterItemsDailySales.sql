SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ItemsRepFilterItemsDailySales]
WITH SCHEMABINDING
AS
	SELECT 
		ItemStoreID, 
		DepartmentID
    FROM           
		DBO.ItemMain 
		INNER JOIN DBO.ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
GO