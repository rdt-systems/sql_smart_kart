SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetBuyersView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@ID uniqueidentifier=null,
@refreshTime  datetime output)
AS

IF @ID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.BuyersView.*
			  FROM         dbo.BuyersView
			  WHERE     DateModified>=isnull(@DateModified,DateModified) 
			  SET @RefreshTime = dbo.GetLocalDATE()
		   RETURN
		END 

if @DateModified is null 
begin
   SELECT     dbo.BuyersView.*
   FROM         dbo.BuyersView
   WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
return
end


if  @DeletedOnly=0 
	 SELECT     dbo.BuyersView.*
   FROM         dbo.BuyersView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	 SELECT     dbo.BuyersView.*
   FROM         dbo.BuyersView
	WHERE     (DateModified>DateModified) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO