SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_LoyaltyGroupView]
(
@DateModified datetime=null
)
AS 
SELECT [LoyaltyGroupView].*  FROM [LoyaltyGroupView]  WHERE (DateModified >@DateModified) AND Status>0
GO