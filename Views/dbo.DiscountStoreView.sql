SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DiscountStoreView]
AS
SELECT        dbo.DiscountStore.*
FROM            dbo.DiscountStore
GO