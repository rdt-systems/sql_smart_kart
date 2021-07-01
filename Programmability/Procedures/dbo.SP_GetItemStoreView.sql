SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemStoreView]
(@StoreID uniqueidentifier,
@DeletedOnly bit =0,
@DateModified datetime=null,
@FromStatus as Int = -1,
@ID uniqueidentifier=null,
@RefreshTime  datetime output)

AS
SET @refreshTime = dbo.GetLocalDATE()

IF @ID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.ItemStoreView.*
			  FROM         dbo.ItemStoreView
			  WHERE     (Status >@FromStatus) AND (StoreNo = @StoreID)AND(ItemStoreID=@ID) AND (DateModified>=isnull(@DateModified,DateModified))and itemno='0094E9C2-A346-44DB-93BF-0000483CC1B9'
			  SET @RefreshTime = dbo.GetLocalDATE()
		   RETURN
		END

IF @DateModified is null 
BEGIN 
      SELECT     dbo.ItemStoreView.*
      FROM         dbo.ItemStoreView
      WHERE     (Status >@FromStatus ) AND (StoreNo = @StoreID)--and itemno='0094E9C2-A346-44DB-93BF-0000483CC1B9'
     
      SET @RefreshTime = dbo.GetLocalDATE()
   RETURN
END


if  @DeletedOnly=0 
		    	SELECT     dbo.ItemStoreView.*
				FROM         dbo.ItemStoreView
				WHERE     (StoreNo = @StoreID) 
							AND (DateModified>=@DateModified) 
							AND (Status >@FromStatus )	
ELSE
 
SELECT     dbo.ItemStoreView.*
FROM         dbo.ItemStoreView
WHERE     (StoreNo = @StoreID) 
		AND (DateModified>=@DateModified) 
		AND (Status =-1)
GO