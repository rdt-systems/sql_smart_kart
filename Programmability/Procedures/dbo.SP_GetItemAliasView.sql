SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemAliasView]
(@DeletedOnly bit =0,
@DateModified datetime=null,
@ID uniqueidentifier=null,
@refreshTime  datetime output)
AS

IF @ID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.ItemAliasView.*
			  FROM         dbo.ItemAliasView
			  WHERE     DateModified>=isnull(@DateModified,DateModified) AND ItemNo=@ID AND (Status =1)
			  SET @RefreshTime = dbo.GetLocalDATE()
		   RETURN
		END


if @DateModified is null 
begin
    SELECT    *
    FROM         dbo.ItemAliasView
    WHERE     (Status =1)
set @refreshTime = dbo.GetLocalDATE()
return
end


if  @DeletedOnly=0 
	  SELECT    *
    FROM         dbo.ItemAliasView
	WHERE     (DateModified>@DateModified)  
	
	 AND (Status =1)

else
	  SELECT    *
    FROM         dbo.ItemAliasView
	WHERE     (DateModified>@DateModified) 	
                AND  (Status = - 1)

set @refreshTime = dbo.GetLocalDATE()
GO