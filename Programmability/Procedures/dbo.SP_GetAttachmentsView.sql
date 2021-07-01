SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetAttachmentsView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@StoreID uniqueidentifier,
@ID uniqueidentifier=null,
@refreshTime  datetime output)

AS
IF @ID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.AttachmentsView.*
			  FROM         dbo.AttachmentsView
			  WHERE     DateModified>=isnull(@DateModified,DateModified) AND ItemStoreID=@ID And StoreID=@StoreID
			  SET @RefreshTime = dbo.GetLocalDATE()
		   RETURN
		END 

if @DateModified is null 
begin

 SELECT     dbo.AttachmentsView.*
FROM         dbo.AttachmentsView
WHERE     (Status > - 1) And (StoreID=@StoreID)
set @refreshTime = dbo.GetLocalDATE()
return
end


if  @DeletedOnly=0 
   SELECT     dbo.AttachmentsView.*
   FROM         dbo.AttachmentsView
	WHERE     (DateModified>@DateModified) And (StoreID=@StoreID)
	
	 AND (Status > - 1)

else
  SELECT     dbo.AttachmentsView.*
  FROM         dbo.AttachmentsView
	WHERE     (DateModified>@DateModified) And (StoreID=@StoreID)
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO