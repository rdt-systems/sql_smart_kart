SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_LoyaltySetupView]
(
@DateModified datetime=null
)
AS 
SELECT [LoyaltySetupView].*  FROM [LoyaltySetupView]  WHERE (DateModified >@DateModified) AND Status>0
GO