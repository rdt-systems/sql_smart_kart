SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetReceiveEntry]
(@Filter nvarchar(4000),
@Stores Guid_list_tbltype  READONLY)
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT  ReceiveOrderView.StoreName,   (CASE WHEN ISNULL(CaseCost, 0) = 0 THEN ReceiveEntryView.UOMPrice ELSE CaseCost END) AS Cost,ReceiveEntryView.CaseQty,  ISNULL(ReceiveEntryView.UOMQty, 0) AS Qty, 
                      CASE WHEN dbo.ReceiveEntryView.UOMType = 0 THEN ''Pc.'' WHEN dbo.ReceiveEntryView.UOMType = 1 THEN ''Dz'' ELSE ''Case'' END AS UOMType, 
                      ReceiveOrderView.ReceiveID, ReceiveOrderView.DateCreated, Supplier.SupplierNo, Bill.BillNo, ReceiveOrderView.ReceiveOrderDate, IsNull(ReceiveEntryView.NetCost,CaseCost)As NetCost, 
                      CAST(PcCost AS decimal(10, 2)) AS PcCost, ReceiveEntryView.Note,  
                      Supplier.Name, Bill.BillDate AS [Bill Date],ReceiveEntryView.Discount, ReceiveEntryView.BinLocation, ReceiveEntryView.ItemAlias
FROM         Supplier INNER JOIN
                      ReceiveOrderView ON Supplier.SupplierID = ReceiveOrderView.SupplierNo INNER JOIN
                      Bill ON ReceiveOrderView.BillID = Bill.BillID RIGHT OUTER JOIN
                      ReceiveEntryView ON ReceiveOrderView.ReceiveID = ReceiveEntryView.ReceiveNo
WHERE   '

print @MySelect + @Filter

set @MySelect =@MySelect +@Filter
 exec sp_executesql @query=@MySelect , @params=N'@Stores Guid_list_tbltype READONLY ', @Stores=@Stores
--Execute (@MySelect + @Filter )
GO