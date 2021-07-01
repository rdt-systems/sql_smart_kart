SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SaleTYpesView]
AS
SELECT     SaleTypeNo, SaleTypeName
FROM         dbo.SaleTypes
GO