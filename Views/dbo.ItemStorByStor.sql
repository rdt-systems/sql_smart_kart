SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[ItemStorByStor]
AS
SELECT     dbo.Store.*
FROM         dbo.ItemStore INNER JOIN
                      dbo.Store ON dbo.ItemStore.StoreNo = dbo.Store.StoreID
GO