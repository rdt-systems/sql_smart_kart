SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[AdjustInventoryView]
AS
SELECT     dbo.AdjustInventory.*
FROM         dbo.AdjustInventory
GO