SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TransferEntryPrint](@ID uniqueidentifier, 
@MySort nvarchar(100) = NULL)
AS 

IF ISNULL(@MySort,'') = ''
SET @MySort = 'BarcodeNumber'

Declare @MySelect nvarchar(4000)
SET @MySelect = 'select ItemMainAndStoreGrid.BarcodeNumber
	 , ItemMainAndStoreGrid.Name
	 , TransferEntry.UOMPrice
	 , TransferEntry.UOMQty
	 , TransferEntry.TransferID
	 , TransferEntry.UOMType
	 , TransferEntry.TransferEntryID
	 , ItemMainAndStoreGrid.ModalNumber
	 , ItemMainAndStoreGrid.BinLocation
	 , ItemMainAndStoreGrid.[Supplier Item Code]	 as ALU
	 , ItemMainAndStoreGrid.ItemAlias
	 , TransferEntry.SortOrder
	 , convert(decimal, ItemMainAndStoreGrid.OnHand) as OnHand
	 , (case
				 when isnull(TransferEntry.Cost, 0) = 0 then
					 ItemMainAndStoreGrid.Cost
				 else
					 TransferEntry.Cost
	   end)											 as Cost
	 , TransferEntry.Note
	 , TransferEntry.ReceiveQty
	 , TransferEntry.ReciveUOMQty
from ItemMainAndStoreView as ItemMainAndStoreGrid
	inner join TransferEntryView TransferEntry
		on ItemMainAndStoreGrid.ItemStoreID = TransferEntry.ItemStoreNo 
WHERE        (TransferEntry.TransferID = ''' + CONVERT(nvarchar(50),@ID) + ''') AND (TransferEntry.Status > 0)
ORDER BY '


Print (@MySelect + @MySort)
Execute (@MySelect + @MySort)
GO