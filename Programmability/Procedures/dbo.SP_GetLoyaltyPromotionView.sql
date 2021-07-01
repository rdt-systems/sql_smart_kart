SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetLoyaltyPromotionView]
	(@DeletedOnly bit =0,
	@DateModified datetime=null, 
	@ID uniqueidentifier=null,
	@refreshTime  datetime output)
AS


if @DateModified is null 
begin
	SELECT * 
	from LoyaltyPromotionView
	Where Status > -1
Set @refreshTime = dbo.GetLocalDATE()
 return
end

IF @ID IS NOT NULL
BEGIN 
	SELECT * 
	from LoyaltyPromotionView
	Where Status > -1 and LoyaltyPromotionID = @ID and DateModified>=@DateModified
Set @refreshTime = dbo.GetLocalDATE()
 return
end

if  @DeletedOnly=0 
	SELECT * 
	from LoyaltyPromotionView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT * 
	from LoyaltyPromotionView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status > = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO