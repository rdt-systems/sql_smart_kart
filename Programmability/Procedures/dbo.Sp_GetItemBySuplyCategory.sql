SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_GetItemBySuplyCategory]
(@doc  Nvarchar(4000))
as
--DECLARE @Root Nvarchar(4000)
--DECLARE @idoc int
--set @Root = 'ROOT/GetItemBySuplyCategory__x0020_IN'
--Set @idoc = 1
--EXEC sp_xml_preparedocument @idoc OUTPUT, @doc


-- SELECT     dbo.ItemMain.Name, dbo.Supplier.Name AS Expr1, dbo.Category.CategoryName
--FROM         dbo.ItemMain INNER JOIN
--                      dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo INNER JOIN
--                      dbo.ItemSupply ON dbo.ItemStore.ItemStoreID = dbo.ItemSupply.ItemStoreNo INNER JOIN
--                      dbo.[StoreItem_Category Link] ON dbo.ItemStore.ItemStoreID = dbo.[StoreItem_Category Link].StoreItemNo INNER JOIN
--                      dbo.Category ON dbo.[StoreItem_Category Link].CategoryNo = dbo.Category.CategoryID INNER JOIN
--                      dbo.Supplier ON dbo.ItemSupply.SupplierNo = dbo.Supplier.SupplierID


--   WHERE           dbo.Supplier.SupplierID in (SELECT top 1 SupplierID FROM OPENXML (@idoc,  @Root ,1)   WITH ( SupplierID uniqueidentifier) )
               
                    
                  
--	    and            dbo.Category.CategoryID  in (SELECT CategoryID   FROM OPENXML (@idoc,  @Root, 1)   WITH ( CategoryID uniqueidentifier) )
GO