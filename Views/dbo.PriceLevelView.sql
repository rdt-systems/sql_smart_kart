SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PriceLevelView]
AS
SELECT     dbo.PriceLevel.*
FROM         dbo.PriceLevel
GO