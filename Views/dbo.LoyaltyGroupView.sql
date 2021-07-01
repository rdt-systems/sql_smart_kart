SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[LoyaltyGroupView]
AS
SELECT     dbo.LoyaltyGroup.*
FROM         dbo.LoyaltyGroup
GO