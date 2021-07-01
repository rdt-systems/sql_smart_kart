SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSubstitueItemsView]
(@StoreID  uniqueidentifier,
@DeletedOnly bit =0,
@ID uniqueidentifier=null,
@DateModified datetime=null, 
@refreshTime  datetime output)
AS 

IF @ID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.SubstitueItemsView.*
			  FROM         dbo.SubstitueItemsView
			  WHERE     DateModified>isnull(@DateModified,DateModified) And StoreNo=@StoreID AND ItemNo=@ID
			  SET @RefreshTime = dbo.GetLocalDATE()
		   RETURN
		END


if @DateModified is null 
begin
	SELECT     dbo.SubstitueItemsView.*
	FROM         dbo.SubstitueItemsView
	WHERE     (Status > - 1 And StoreNo=@StoreID)
set @refreshTime = dbo.GetLocalDATE()
   return
end


if  @DeletedOnly=0 
	SELECT     dbo.SubstitueItemsView.*
	FROM         dbo.SubstitueItemsView
	WHERE     (DateModified>@DateModified And StoreNo=@StoreID) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.SubstitueItemsView.*
	FROM         dbo.SubstitueItemsView
	WHERE     (DateModified>@DateModified And StoreNo=@StoreID) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO