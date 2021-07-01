SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPrintLabelsView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@StoreID uniqueidentifier = null,
@refreshTime  datetime output )
AS

--Set @StoreID=(SELECT OptionName
--   FROM SetUpValues
--   Where OptionID=999)

if @DateModified is null 
begin
     SELECT    PrintLabelsID,P.ItemStoreID,Tag,P.Status,P.DateCreated,P.UserCreated,P.DateModified,P.UserModified, 
		 M.BarcodeNumber, M.ModalNumber, M.Name,ISNULL(Qty,1) as Qty,S.OnHand
         FROM         dbo.PrintLabels P INNER JOIN
                      dbo.ItemStore S ON P.ItemStoreID = S.ItemStoreID INNER JOIN
					  dbo.ItemMain M ON M.ItemID = S.ItemNo
    WHERE     (P.Status > - 1) And (S.StoreNo=@StoreID)
Order By P.DateCreated
set @refreshTime = dbo.GetLocalDATE()
 return
end


if  @DeletedOnly=0 
     SELECT    PrintLabelsID,P.ItemStoreID,Tag,P.Status,P.DateCreated,P.UserCreated,P.DateModified,P.UserModified, 
		 M.BarcodeNumber, M.ModalNumber, M.Name,ISNULL(Qty,1) as Qty,S.OnHand
         FROM         dbo.PrintLabels P INNER JOIN
                      dbo.ItemStore S ON P.ItemStoreID = S.ItemStoreID INNER JOIN
					  dbo.ItemMain M ON M.ItemID = S.ItemNo
         WHERE     (P.DateModified>@DateModified) 
	 AND (P.Status > - 1) And (S.StoreNo=@StoreID)
Order By DateCreated
else
   SELECT    PrintLabelsID,P.ItemStoreID,Tag,P.Status,P.DateCreated,P.UserCreated,P.DateModified,P.UserModified, 
		 M.BarcodeNumber, M.ModalNumber, M.Name,ISNULL(Qty,1) as Qty,S.OnHand
         FROM         dbo.PrintLabels P INNER JOIN
                      dbo.ItemStore S ON P.ItemStoreID = S.ItemStoreID INNER JOIN
					  dbo.ItemMain M ON M.ItemID = S.ItemNo
         WHERE     (P.DateModified>@DateModified) 
	                AND  (P.Status = - 1) And (StoreNo=@StoreID)
Order By DateCreated
set @refreshTime = dbo.GetLocalDATE()
GO