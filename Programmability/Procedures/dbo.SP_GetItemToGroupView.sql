SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemToGroupView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@ID uniqueidentifier=null,
@StoreID uniqueidentifier,
@refreshTime  datetime output)
AS

IF @ID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.ItemToGroupView.*
			  FROM         dbo.ItemToGroupView
			  WHERE     DateModified>=isnull(@DateModified,DateModified) AND ItemStoreID=@ID And StoreID=@StoreID
			  SET @RefreshTime = dbo.GetLocalDATE()
		   RETURN
		END 

if @DateModified is null 
begin
   SELECT     dbo.ItemToGroupView.*
   FROM         dbo.ItemToGroupView
   WHERE     (Status > - 1) And (StoreID=@StoreID)
set @refreshTime = dbo.GetLocalDATE()
return
end


if  @DeletedOnly=0 
	 SELECT     dbo.ItemToGroupView.*
   FROM         dbo.ItemToGroupView
	WHERE     (DateModified>@DateModified) And (StoreID=@StoreID)
	
	 AND (Status > - 1)

else
	 SELECT     dbo.ItemToGroupView.*
   FROM         dbo.ItemToGroupView
	WHERE     (DateModified>DateModified) And (StoreID=@StoreID)
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO