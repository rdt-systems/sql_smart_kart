SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetBestOrWorstSellers]  
(@Number int,  
@Desc nvarchar(4000),  
@Filter nvarchar(4000),  
@ItemFilter nvarchar(4000),  
@CustomerFilter nvarchar(4000))  
  
AS   
  
declare @MyWhere nvarchar(4000)  
  
declare @ItemSelect nvarchar(4000)  
Set  @ItemSelect='Select ItemStoreID   
      Into #ItemSelect   
                  From ItemsRepFilter   
                  Where (1=1) '  
  
if @CustomerFilter<>''  
  
 begin   
  declare @CustomerSelect nvarchar(4000)  
  Set  @CustomerSelect=' Select CustomerID   
          Into #CustomerSelect   
         From CustomerRepFilter   
         Where (1=1) '  
  SET @MyWhere= ' where TransactionEntryProfit.ItemStoreID<>''00000000-0000-0000-0000-000000000000''  And exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryProfit.ItemStoreID) And  exists (Select 1 From #CustomerSelect where CustomerID=TransactionEntryProfit.CustomerID ) '  
 end   
   
ELSE  
 SET @MyWhere= ' where TransactionEntryProfit.ItemStoreID<>''00000000-0000-0000-0000-000000000000''  And exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryProfit.ItemStoreID) '  
  
--*********************************************  
  
declare @MySelect1 nvarchar(4000)  
set @MySelect1='SELECT Top '    
  
declare @MySelect2 nvarchar(4000)  
set @MySelect2='    
          CASE WHEN PARSENAME(CAST(SUM(dbo.TransactionEntryProfit.QtyCase) as decimal(18,2)),1) <> 0 and (ItemMainAndStoreGrid.ItemType <>0 or LEN(BarcodeNumber) <=6) THEN CAST(SUM(dbo.TransactionEntryProfit.QtyCase) as decimal(18,2)) ELSE SUM(dbo.TransactionEntryProfit.Qty) END AS Qty,  
     dbo.ItemMainAndStoreGrid.Name,  
  dbo.ItemMainAndStoreGrid.BarcodeNumber,  
  dbo.ItemMainAndStoreGrid.ModalNumber,   
  dbo.TransactionEntryProfit.ItemStoreID,   
        dbo.ItemMainAndStoreGrid.BarcodeNumber,  
  dbo.ItemMainAndStoreGrid.Brand,  
 -- (CASE WHEN IsNull(ParentCode,'''')='''' THEN dbo.ItemMainAndStoreGrid.[Supplier Item Code] ELSE ParentCode END)AS ParentCode,  
  dbo.ItemMainAndStoreGrid.DepartmentID,  
  dbo.ItemMainAndStoreGrid.Department,  
  
        SUM(dbo.TransactionEntryProfit.ExtCost) as ExtCost,  
  SUM(dbo.TransactionEntryProfit.Total) as ExtPrice,  
                         
   SUM(dbo.TransactionEntryProfit.QtyCase) AS QtyCase,  
  
  (CASE WHEN SUM(dbo.TransactionEntryProfit.TotalAfterDiscount)=0 then 0  
        ELSE SUM(dbo.TransactionEntryProfit.Profit)/   
       SUM(dbo.TransactionEntryProfit.TotalAfterDiscount)  
         END)  
      as MarginPrice,  
  
         (CASE WHEN SUM(dbo.TransactionEntryProfit.ExtCost) <> 0 then  
       SUM(dbo.TransactionEntryProfit.Profit)/ SUM(dbo.TransactionEntryProfit.ExtCost)  
         ELSE 0  
   END) as MarkupPrice,  
  
   SUM(dbo.TransactionEntryProfit.Profit) as Profit,  
           
    (SUM(ExtPrice) - SUM(TotalAfterDiscount))  as Discount,         
   --SUM(dbo.TransactionEntryProfit.Discount) as Discount,  
         SUM(dbo.TransactionEntryProfit.TotalAfterDiscount) as TotalAfterDiscount,  
   dbo.ItemMainAndStoreGrid.StoreName,  
         dbo.ItemMainAndStoreGrid.ItemID,  
         max(TransactionEntryProfit.Price) as Price,  
         max(dbo.ItemMainAndStoreGrid.OnHand) as OnHand,  
   IsNull(SellTrue.SellThru,0) AS SellThru  
  
  FROM   dbo.TransactionEntryProfit INNER JOIN
  dbo.ItemMainAndStoreGrid ON dbo.TransactionEntryProfit.ItemStoreID = dbo.ItemMainAndStoreGrid.ItemStoreID  LEFT OUTER JOIN  
                             (SELECT        TransactionEntryProfit_1.ItemStoreID, (100 / (SUM(OnHand) + SUM(QTY)) * SUM(QTY)) / 100 AS SellThru  
                               FROM            TransactionEntryProfit AS TransactionEntryProfit_1 INNER JOIN
  dbo.ItemMainAndStoreGrid ON TransactionEntryProfit_1.ItemStoreID = dbo.ItemMainAndStoreGrid.ItemStoreID 
                               GROUP BY TransactionEntryProfit_1.ItemStoreID  
                               HAVING         (SUM(OnHand) > 0) AND (SUM(QTY) > 0)) AS SellTrue ON TransactionEntryProfit.ItemStoreID = SellTrue.ItemStoreID '  
  
declare @MySelect3 nvarchar(4000)  
set @MySelect3='    
  
    GROUP BY   dbo.TransactionEntryProfit.ItemStoreID,   
       dbo.ItemMainAndStoreGrid.Name,   
       dbo.TransactionEntryProfit.ItemStoreID,   
             dbo.ItemMainAndStoreGrid.BarcodeNumber,  
          dbo.ItemMainAndStoreGrid.ModalNumber,  
       dbo.ItemMainAndStoreGrid.StoreName,  
             dbo.ItemMainAndStoreGrid.ItemID,  
       dbo.ItemMainAndStoreGrid.Brand,  
   -- dbo.ItemMainAndStoreGrid.ParentCode,  
    dbo.ItemMainAndStoreGrid.DepartmentID,  
       dbo.ItemMainAndStoreGrid.Department,  
    dbo.ItemMainAndStoreGrid.[Supplier Item Code],
	dbo.ItemMainAndStoreGrid.ItemType,  
    SellThru  
  ORDER BY Qty  '  
  
  
print (@MySelect1 + '10' + @MySelect2 + @MyWhere + @Filter + @MySelect3 + @Desc )  
exec (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect1 + @Number + @MySelect2 + @MyWhere + @Filter + @MySelect3 + @Desc + '; drop table #ItemSelect ')  
  
  
  
 
if @CustomerFilter<>''  
drop table #CustomerSelect
GO