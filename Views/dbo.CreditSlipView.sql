SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[CreditSlipView]
AS
SELECT     dbo.CreditSlip.*
FROM         dbo.CreditSlip
GO