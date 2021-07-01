SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CreditCardView]
AS
SELECT     dbo.CreditCard.*
FROM         dbo.CreditCard
GO