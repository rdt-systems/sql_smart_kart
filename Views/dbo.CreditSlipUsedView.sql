SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CreditSlipUsedView]
AS
SELECT     dbo.CreditSlipUsed.*
FROM         dbo.CreditSlipUsed
GO