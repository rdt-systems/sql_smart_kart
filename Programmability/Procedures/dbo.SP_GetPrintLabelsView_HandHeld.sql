SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPrintLabelsView_HandHeld]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@StoreID uniqueidentifier,
@refreshTime  datetime output )
AS

--Set @StoreID=(SELECT OptionName
--   FROM SetUpValues
--   Where OptionID=999)

if @DateModified is null 
begin
   SELECT    PrintLabelsID,PrintLabels.ItemStoreID,Tag,ISNULL(Qty,1) as Qty
   FROM         dbo.PrintLabels INNER JOIN
                dbo.ItemMainAndStoreView ON dbo.PrintLabels.ItemStoreID = dbo.ItemMainAndStoreView.ItemStoreID
    WHERE     (dbo.PrintLabels.Status > - 1) And (StoreNo=@StoreID)
set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 
   SELECT PrintLabelsID,PrintLabels.ItemStoreID,Tag,ISNULL(Qty,1) as Qty
		 FROM        dbo.PrintLabels INNER JOIN
                     dbo.ItemMainAndStoreView ON dbo.PrintLabels.ItemStoreID = dbo.ItemMainAndStoreView.ItemStoreID
         WHERE     (DateModified>@DateModified) 
	
	 AND (dbo.PrintLabels.Status > - 1) And (StoreNo=@StoreID)

else
   SELECT  PrintLabelsID,PrintLabels.ItemStoreID,Tag,ISNULL(Qty,1) as Qty  
         FROM         dbo.PrintLabels INNER JOIN
                      dbo.ItemMainAndStoreView ON dbo.PrintLabels.ItemStoreID = dbo.ItemMainAndStoreView.ItemStoreID
         WHERE     (DateModified>@DateModified) 
	
                AND  (dbo.PrintLabels.Status = - 1) And (StoreNo=@StoreID)
set @refreshTime = dbo.GetLocalDATE()
GO