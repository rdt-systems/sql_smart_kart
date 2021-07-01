SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetMatrixItemView]
(@ItemLinkID uniqueidentifier ,
 @StoreID uniqueidentifier
--,@DeletedOnly bit =0
--,@DateModified datetime=null
--,@refreshTime  datetime output
)
AS

Select ItemID,ItemStoreID from ItemMainAndStoreView where LinkNo =@ItemLinkID and storeNo=@StoreID

--if @DateModified is null 
--begin
--SELECT     dbo.MatrixItemView.*
--FROM         dbo.MatrixItemView
--WHERE     (Status > - 1)
--set @refreshTime = dbo.GetLocalDATE()
--return
--end


--if  @DeletedOnly=0 
--SELECT     dbo.MatrixItemView.*
--FROM         dbo.MatrixItemView
--WHERE     (DateModified>@DateModified) 
	
--	 AND (Status > - 1)

--else
--SELECT     dbo.MatrixItemView.*
--FROM         dbo.MatrixItemView
--WHERE     (DateModified>@DateModified) 
	
--                AND  (Status = - 1)
--set @refreshTime = dbo.GetLocalDATE()
GO