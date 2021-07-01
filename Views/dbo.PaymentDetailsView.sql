SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PaymentDetailsView]
AS
SELECT     dbo.PaymentDetails.*
FROM         dbo.PaymentDetails
GO