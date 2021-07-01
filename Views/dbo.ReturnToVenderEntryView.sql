SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE        VIEW [dbo].[ReturnToVenderEntryView]
AS
SELECT     dbo.ReturnToVenderEntry.*,
(Qty*Cost)/isnull(case When ReturnToVenderEntry.UOMQty <> 0 then ReturnToVenderEntry.UOMQty else 1 end,case When ReturnToVenderEntry.Qty <> 0 then ReturnToVenderEntry.Qty else 1 end) as UOMPrice
FROM         dbo.ReturnToVenderEntry
GO