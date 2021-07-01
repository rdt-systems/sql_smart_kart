SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetPriceChange]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000)
)

AS 

DECLARE @MySelect nvarchar(4000)

DECLARE @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

set @MySelect='SELECT     PriceChangeHistory.ItemStoreID, ItemMainAndStoreView.ItemID,  PriceChangeHistory.PriceLevel, PriceChangeHistory.OldPrice, PriceChangeHistory.NewPrice, 
                         PriceChangeHistory.Date AS ChangeDate, PriceChangeHistory.SaleDate, PriceChangeHistory.SaleType, PriceChangeHistory.SP_Price, 
                         ItemMainAndStoreView.Department, ItemMainAndStoreView.Name, ItemMainAndStoreView.ModalNumber, ItemMainAndStoreView.BarcodeNumber, 
                         ItemMainAndStoreView.Brand, tmpUsers.UserName
FROM            PriceChangeHistory INNER JOIN
                         ItemMainAndStoreView ON PriceChangeHistory.ItemStoreID = ItemMainAndStoreView.ItemStoreID INNER JOIN
                             (SELECT        UserId AS MyUserID, UserName
                               FROM            Users) AS tmpUsers ON PriceChangeHistory.UserID = tmpUsers.MyUserID'


Print   (@ItemSelect +@MySelect  + @Filter )
Execute (@ItemSelect + @ItemFilter + @MySelect   + @Filter )


drop table #ItemSelect
GO