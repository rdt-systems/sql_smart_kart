SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[_dta_mv_2]
AS
SELECT     dbo.ItemStore.Status AS _col_1, dbo.ItemMain.Status AS _col_2, dbo.ItemStore.DateModified AS _col_3, dbo.ItemStore.ItemStoreID AS _col_4
FROM         dbo.ItemStore INNER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID
GO