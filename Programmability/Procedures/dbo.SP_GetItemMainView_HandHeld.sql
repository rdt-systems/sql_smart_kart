SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemMainView_HandHeld]
(@DeletedOnly bit =0,
@DateModified datetime=null,
@ID uniqueidentifier=null,
@refreshTime  datetime output)
AS 

set @refreshTime = dbo.GetLocalDATE()

IF @ID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.ItemMainView.ItemID,dbo.ItemMainView.[Name], dbo.ItemMainView.Description,dbo.ItemMainView.BarcodeNumber
			  FROM       dbo.ItemMainView
			  WHERE     DateModified>=isnull(@DateModified,DateModified) AND ItemID=@ID
			  SET @RefreshTime = dbo.GetLocalDATE()
		   RETURN
		END

if @DateModified is null 
begin
      SELECT     dbo.ItemMainView.ItemID,dbo.ItemMainView.[Name], dbo.ItemMainView.Description,dbo.ItemMainView.BarcodeNumber
      FROM         dbo.ItemMainView
      WHERE     (Status> -1 )--and itemid='0094E9C2-A346-44DB-93BF-0000483CC1B9'
set @refreshTime = dbo.GetLocalDATE()
   return
end


if  @DeletedOnly=0 
	SELECT     dbo.ItemMainView.ItemID,dbo.ItemMainView.[Name], dbo.ItemMainView.Description, dbo.ItemMainView.BarcodeNumber
	FROM         dbo.ItemMainView
	WHERE     (DateModified>=@DateModified) --and itemid='0094E9C2-A346-44DB-93BF-0000483CC1B9'
	
	 AND (Status >-1 )	
else
	SELECT     dbo.ItemMainView.ItemID,dbo.ItemMainView.[Name], dbo.ItemMainView.Description, dbo.ItemMainView.BarcodeNumber
	FROM         dbo.ItemMainView
	WHERE     (DateModified>=@DateModified ) 
                AND  (Status =-1)
GO