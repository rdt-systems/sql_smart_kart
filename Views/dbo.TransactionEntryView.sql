SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TransactionEntryView]
AS
SELECT        TransactionEntry.Sort, TransactionEntry.TransactionEntryType, TransactionEntry.Taxable, TransactionEntry.Qty, TransactionEntry.UOMType, ISNULL(CAST(TransactionEntry.UOMQty AS decimal(19, 3)), 
                         CAST(TransactionEntry.Qty AS decimal(19, 3))) AS UOMQty, TransactionEntry.DiscountPerc, TransactionEntry.DiscountAmount, TransactionEntry.SaleCode, TransactionEntry.PriceExplanation, 
                         TransactionEntry.ParentTransactionEntry, TransactionEntry.AVGCost, (CASE WHEN dbo.TransactionEntry.UOMType = 2 THEN (ISNULL(dbo.TransactionEntry.Cost, 0) * ISNULL(ItemMainAndStoreReportView.CaseQty, 1)) 
                         ELSE dbo.TransactionEntry.Cost END) AS Cost, TransactionEntry.ReturnReason, TransactionEntry.Note, TransactionEntry.Status, TransactionEntry.DateCreated, TransactionEntry.UserCreated, 
                         TransactionEntry.DateModified, TransactionEntry.UserModified, 
						 CASE WHEN Coupon.CouponNo IS NOT NULL THEN TransactionEntry.Note WHEN ISNULL(ISNULL(ItemMainAndStoreReportView.Name, EntryDescription.Description), '') = '' AND 
                         Sort < 2000 THEN 'MANUAL ITEM' WHEN ISNULL(EntryDescription.Description,ISNULL(ItemMainAndStoreReportView.Name, '')) = '' AND 
                         Sort > 2000 THEN 'Discount' ELSE ISNULL(ISNULL(ItemMainAndStoreReportView.Name, EntryDescription.Description), '[MANUAL ITEM]') END COLLATE SQL_Latin1_General_CP1_CI_AS AS Name, ItemMainAndStoreReportView.BarcodeNumber AS ItemCode, 
                         ItemMainAndStoreReportView.ModalNumber, TransactionEntry.UOMPrice, TransactionEntry.Total, TransactionEntry.DepartmentID, TransactionEntry.TransactionEntryID, TransactionEntry.TransactionID, 
                         TransactionEntry.ItemStoreID, TransactionEntry.DiscountOnTotal, ItemMainAndStoreReportView.Price, ItemMainAndStoreReportView.OnHand, ItemMainAndStoreReportView.ItemID , ISNULL(TransactionEntry.RegUnitPrice,ISNULL(ItemMainAndStoreReportView.Price,0)) AS RegUnitPrice,
						 TransactionEntry.TotalAfterDiscount
FROM            TransactionEntry LEFT OUTER JOIN
						 ItemMainAndStoreReportView ON TransactionEntry.ItemStoreID = ItemMainAndStoreReportView.ItemStoreID LEFT OUTER JOIN
                         EntryDescription ON TransactionEntry.TransactionEntryID = EntryDescription.TransactionEntryID LEFT OUTER JOIN
                         Coupon ON TransactionEntry.TransactionEntryID = Coupon.CouponID
WHERE TransactionEntry.Status > -1
                       
GO