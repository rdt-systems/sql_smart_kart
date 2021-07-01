SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemNotesView]
AS
SELECT     TOP 100 PERCENT dbo.ItemNotes.*,StoreNo as StoreID
FROM         dbo.ItemNotes INNER JOIN ItemStore On ItemStoreNo=ItemStoreID
ORDER BY ItemStoreNo
GO