SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetLoyaltyGroupView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@ID uniqueidentifier=null,
@refreshTime  datetime output)

AS

 	SELECT     dbo.LoyaltyGroupView.*
	FROM       dbo.LoyaltyGroupView
	WHERE     (Status > 0)
GO