SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetLoyaltySetupView]
AS

SELECT     dbo.LoyaltySetupView.*
FROM         dbo.LoyaltySetupView
GO