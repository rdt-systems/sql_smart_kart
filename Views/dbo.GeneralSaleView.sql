SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[GeneralSaleView]
AS
SELECT     dbo.GeneralSale.*
FROM         dbo.GeneralSale
GO