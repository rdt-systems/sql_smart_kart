SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReturnItemView]
AS
SELECT     dbo.ReturnItem.*
FROM         dbo.ReturnItem
GO