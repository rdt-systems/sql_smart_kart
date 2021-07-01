SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[GiftRegistryView]
AS
SELECT     dbo.GiftRegistery.EventDate, dbo.GiftRegistery.EventType, dbo.GiftRegistery.CustomerID, dbo.GiftRegistery.GiftRegisteryID, dbo.CustomerView.Name, 
                      dbo.GiftRegistery.GiftRegisteryNo AS RegNo, dbo.GiftRegistery.EventName AS Event, dbo.CustomerView.Address
FROM         dbo.GiftRegistery INNER JOIN
                      dbo.CustomerView ON dbo.GiftRegistery.CustomerID = dbo.CustomerView.CustomerID
WHERE     (dbo.GiftRegistery.Status > 0)
GO