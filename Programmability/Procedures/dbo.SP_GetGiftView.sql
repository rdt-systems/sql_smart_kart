SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetGiftView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS


if @DateModified is null 
begin

   SELECT     dbo.GiftView.*
   FROM         dbo.GiftView
   WHERE     (Status > - 1)

set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 

	SELECT     dbo.GiftView.*
    FROM         dbo.GiftView
   	WHERE     (DateModified>@DateModified)
			 AND (Status > - 1)

else

	SELECT     dbo.GiftView.*
    FROM         dbo.GiftView
   	WHERE     (DateModified>@DateModified) 
              AND  (Status = - 1)

set @refreshTime = dbo.GetLocalDATE()
GO