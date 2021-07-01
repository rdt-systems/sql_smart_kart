SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetEntryBySupplierID]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.TransactionEntryView.Name,
						   dbo.TransactionEntryView.ItemCode,
						   dbo.TransactionEntryView.ModalNumber, 
						   Abs(dbo.TransactionEntryView.Qty) as Qty,
						   abs(dbo.TransactionEntryView.UOMPrice) as UOMPrice,
						   dbo.TransactionEntryView.UOMType,
						   dbo.SysUOMTypeView.SystemValueName as UOM,
						   Abs(dbo.TransactionEntryView.Total)as Total,
						   dbo.TransactionEntryView.ItemStoreID

				FROM       dbo.TransactionEntryView inner JOIN
						   dbo.[Transaction] On dbo.TransactionEntryView.TransactionID = dbo.[Transaction].TransactionID Left Outer JOIN
			               dbo.ItemSupply  ON  dbo.TransactionEntryView.ItemStoreID = dbo.ItemSupply.ItemStoreNo and dbo.ItemSupply.Status >0 and dbo.ItemSupply.IsMainSupplier =1 Left Outer JOIN
						   dbo.SysUOMTypeView ON  dbo.TransactionEntryView.UOMType = dbo.SysUOMTypeView.SystemValueNo 
				where      dbo.TransactionEntryView.TransactionEntryType=2 and dbo.TransactionEntryView.Status> 0 and dbo.TransactionEntryView.ReturnReason=0'
Execute (@MySelect + @Filter )
GO