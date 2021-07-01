SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetMultiStoreItems]

AS 
SELECT     dbo.ItemMain.Name,
		   dbo.ItemMain.ModalNumber,
		   dbo.ItemMain.BarcodeNumber, 
		   dbo.ItemStore.OnHand,	
		   dbo.ItemStore.OnOrder,
           dbo.DepartmentStore.Name AS Department, 
           dbo.Store.StoreName

FROM       dbo.ItemMain INNER JOIN
           dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo  LEFT OUTER JOIN 
           dbo.DepartmentStore ON dbo.ItemStore.DepartmentID = dbo.DepartmentStore.DepartmentStoreID INNER JOIN
           dbo.Store ON dbo.ItemStore.StoreNo = dbo.Store.StoreID

Where ItemStore.Status>0 AND ItemType<>2
GO