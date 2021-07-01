SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetReceiveEntryToApprove]
(@FromDate datetime,
@ToDate datetime)

as
Select ReceiveEntryID,ReceiveOrderView.SupplierNo as SupplierNoEntry,ReceiveNo,ItemStoreNo,UOMPrice as Cost, Items.[Name],Items.BarcodeNumber,Items.[CurrentCost],Cast (0 as Bit) as ForApprove
from ReceiveEntryView inner join
		(Select [Name],BarcodeNumber,Cost as [CurrentCost],ItemStoreID
		 from ItemMainAndStoreView
		 group by ItemStoreID,[Name],BarcodeNumber,Cost) Items On Items.ItemStoreID=ReceiveEntryView.ItemStoreNo inner Join 
                 ReceiveOrderView On ReceiveOrderView.ReceiveID = ReceiveEntryView.ReceiveNo 
Where ForApprove=1 and ReceiveEntryView.Status>0 And ReceiveOrderView.BillDate>=@FromDate and ReceiveOrderView.BillDate<@ToDate
GO