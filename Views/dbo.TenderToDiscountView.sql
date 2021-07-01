SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TenderToDiscountView]
AS
SELECT     dbo.TenderToDiscount.*
FROM         dbo.TenderToDiscount
GO