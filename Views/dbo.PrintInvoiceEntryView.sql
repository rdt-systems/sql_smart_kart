SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   VIEW [dbo].[PrintInvoiceEntryView]
AS
SELECT     convert(Decimal(19,3),convert(nchar(10),dbo.TransactionEntryView.UOMQty)) as Qty, dbo.TransactionEntryView.UOMPrice, dbo.TransactionEntryView.ModalNumber, 
                      '' as [Description], dbo.TransactionEntryView.ItemCode, dbo.TransactionEntryView.Total, dbo.TransactionEntryView.DiscountPerc, 
                      dbo.TransactionEntryView.Taxable, dbo.TransactionEntryView.Note, dbo.TransactionEntryView.Name, 
                      dbo.SysUOMTypeView.SystemValueName AS [Cs/Pc/Ds], dbo.TransactionEntryView.TransactionID, dbo.TransactionEntryView.Sort
FROM         dbo.TransactionEntryView LEFT OUTER JOIN
                      dbo.SysUOMTypeView ON dbo.TransactionEntryView.UOMType = dbo.SysUOMTypeView.SystemValueNo LEFT OUTER JOIN
                      dbo.ItemMainAndStoreView ON dbo.TransactionEntryView.ItemStoreID = dbo.ItemMainAndStoreView.ItemStoreID
GO