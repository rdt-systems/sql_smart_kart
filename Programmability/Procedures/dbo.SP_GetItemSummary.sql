SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--SP_GetItemSummary ' And EndSaleTime>=''2020-08-30'' And EndSaleTime<''2020-09-04''','','',' TransactionEntryItem ','cfbcabdb-4187-4b33-8c06-15d6be44eda8'  
  
CREATE PROCEDURE [dbo].[SP_GetItemSummary]    
(@Filter varchar(max),    
 @ItemFilter varchar(max),    
 @CustomerFilter varchar(max),    
 @TableName nvarchar(100)='TransactionEntryItem',    
 @ModifierID  uniqueidentifier = null    
 )    
    
AS     
    
 exec tolog @Filter    
DECLARE @MySelect varchar(max)    
DECLARE @MyGroup varchar(max)    
DECLARE @MyWhere varchar(max)    
    
declare @ItemSelect varchar(max)    
Set  @ItemSelect='Select ItemStoreID     
      Into #ItemSelect     
                  From ItemsRepFilter     
                  Where (1=1) '    
    
if @CustomerFilter<>''    
    
 begin     
  declare @CustomerSelect varchar(max)    
  Set  @CustomerSelect=' Select CustomerID     
         Into #CustomerSelect     
         From CustomerRepFilter     
         Where (1=1) '    
  SET @MyWhere= ' where (1=1)  And  exists (Select 1 From #CustomerSelect where CustomerID= '+@TableName+'.CustomerID ) '    
 end     
     
ELSE    
 SET @MyWhere= ' where (1=1)  '    
    
 if ( select top 1  BO_SelectedDepartment     
 from [UserQuery]     
 where [UserQuery].UserId=@ModifierID) = 1    
 begin     
 set @MyWhere =@MyWhere + ' and DepartmentID in (    
 SELECT [DepartmentID]    
    FROM [Develop].[dbo].[DepartmentToUserGroup]    
    where [Status] =1    
    and  [GroupID] in (select GroupID     
    from UserQuery    
    where UserQuery.UserId='''+convert(varchar(100),@ModifierID)+'''))'    
 end    
    
--*********************************************    
IF (Select COUNT(*) from SetUpValues where OptionID = 100 and ((OptionValue = '1') or(OptionValue = 'True')) And StoreID <> '00000000-0000-0000-0000-000000000000') >0    
set @MySelect='    
    SELECT  '+@TableName+'.ItemStoreID,    
      Name,    
   Groups,     
   ParentName,    
   Color,    
   Size,    
   ModalNumber,    
      BarcodeNumber,     
      ItemTypeName,     
            Department,    
   DepartmentID,    
   MainDepartment,    
   SubDepartment,    
   SubSubDepartment,    
   StyleNo,    
   (CASE WHEN IsNull(Supplier,'''')='''' THEN ParentSupplerName  ELSE Supplier END)As Supplier,    
   SupplierCode as ItemCodeSupplier,    
   Brand,    
   CustomerCode,    
   SUM(Qty) AS Qty,    
         SUM(QtyCase) AS QtyCase,    
         SUM(ExtCost) as ExtCost,    
         SUM(Total) as ExtPrice,     
   (CASE WHEN SUM(ISNULL(ExtPrice,0)) = 0 OR SUM(ISNULL(TotalAfterDiscount,0)) = 0 THEN 0 WHEN SUM(ISNULL(ExtPrice,0)) <> 0 AND SUM(ISNULL(TotalAfterDiscount,0)) <> 0      
   AND CAST((SUM(ExtPrice) - SUM(TotalAfterDiscount)) As numeric) <> 0 THEN     
   ((((SUM(ExtPrice) - SUM(TotalAfterDiscount))) / SUM(ExtPrice)) ) ELSE NULL END )  AS [Discount %] ,    
   --(SUM(ExtPrice) / (SUM(ExtPrice) - SUM(TotalAfterDiscount)))    
    --     (CASE WHEN SUM(TotalAfterDiscount)=0 then 0     
    --  ELSE SUM(Profit)/     
    --        SUM(TotalAfterDiscount)    
    --END) as MarginPrice,    
   (CASE WHEN SUM(TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0    
     ELSE ((SUM(Profit))/     
    (SUM(TotalAfterDiscount)/100))/100    
             END)    
       as MarginPrice,    
    
          (CASE  WHEN SUM(ExtCost) <> 0     
             THEN SUM(Profit)/    
               SUM(ExtCost)    
         ELSE 0       
    END) as MarkupPrice,    
    
         SUM(Profit) as Profit,    
    
         (SUM(Total) - SUM(TotalAfterDiscount))  as Discount,    
                     
   SUM(TotalAfterDiscount) as TotalAfterDiscount,    
   StoreName,    
   StoreID,    
            ItemID,    
   (CASE WHEN IsNull(SupplierCode,'''')='''' THEN ParentCode  ELSE SupplierCode END)As ParentCode,    
            max(Price) as Price,    
            max(OnHand) as OnHand,    
   (CASE WHEN (IsNull(SUM(Qty),0)+(max(OnHand)))>0 THEN (100 / (max(OnHand) + SUM(QTY)) * SUM(QTY))/100 ELSE 0 END) AS SellThru ,    
   Groups,    
       LastReceivedDate,    
       LastReceivedQty,    
      
     
         CustomField1,    
         CustomField2,    
         CustomField3,    
         CustomField4,    
         CustomField5,    
         CustomField6,    
         CustomField7,    
         CustomField8,    
         CustomField9,    
         CustomField10    
 FROM   dbo.' + @TableName + ' Join #ItemSelect ON ' + @TableName + '.ItemStoreID = #ItemSelect.ItemStoreID '     
    
Else    
set @MySelect='    
    SELECT  '+@TableName+'.ItemStoreID,    
      Name,    
   Groups,    
   ParentName,    
   Color,    
   Size,    
   ModalNumber,    
      BarcodeNumber,     
      ItemTypeName,     
            Department,    
   DepartmentID,    
   '''' AS MainDepartment,    
   '''' AS SubDepartment,    
   '''' AS SubSubDepartment,    
   StyleNo,    
   (CASE WHEN IsNull(Supplier,'''')='''' THEN ParentSupplerName  ELSE Supplier END)As Supplier,    
   SupplierCode as ItemCodeSupplier,    
   Brand,    
   CustomerCode,    
   SUM(Qty) AS Qty,    
         SUM(QtyCase) AS QtyCase,    
         SUM(ExtCost) as ExtCost,    
         SUM(Total) as ExtPrice,    
(CASE WHEN SUM(ISNULL(ExtPrice,0)) = 0 OR SUM(ISNULL(TotalAfterDiscount,0)) = 0 THEN 0 WHEN SUM(ISNULL(ExtPrice,0)) <> 0 AND SUM(ISNULL(TotalAfterDiscount,0)) <> 0      
   AND CAST((SUM(ExtPrice) - SUM(TotalAfterDiscount)) As numeric) <> 0 THEN     
   ((((SUM(ExtPrice) - SUM(TotalAfterDiscount))) / SUM(ExtPrice)) ) ELSE NULL END )  AS [Discount %] ,    
    --     (CASE WHEN SUM(TotalAfterDiscount)=0 then 0     
    --  ELSE SUM(Profit)/     
    --        SUM(TotalAfterDiscount)    
    --END) as MarginPrice,    
   (CASE WHEN SUM(TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0    
     ELSE ((SUM(Profit))/     
    (SUM(TotalAfterDiscount)/100))/100    
             END)    
       as MarginPrice,    
    
          (CASE  WHEN SUM(ExtCost) <> 0     
             THEN SUM(Profit)/    
               SUM(ExtCost)    
         ELSE 0       
    END) as MarkupPrice,    
    
         SUM(Profit) as Profit,    
    
         (SUM(Total) - SUM(TotalAfterDiscount))  as Discount,    
                     
   SUM(TotalAfterDiscount) as TotalAfterDiscount,    
   StoreName,    
   StoreID,    
            ItemID,    
   (CASE WHEN IsNull(SupplierCode,'''')='''' THEN ParentCode  ELSE SupplierCode END)As ParentCode,    
            max(Price) as Price,    
            max(OnHand) as OnHand,    
   (CASE WHEN (IsNull(SUM(Qty),0)+(max(OnHand)))>0 THEN (100 / (max(OnHand) + SUM(QTY)) * SUM(QTY))/100 ELSE 0 END) AS SellThru,    
       Groups,    
       LastReceivedDate,    
       LastReceivedQty,    
        CustomField1,    
         CustomField2,    
         CustomField3,    
         CustomField4,    
         CustomField5,    
         CustomField6,    
         CustomField7,    
         CustomField8,    
         CustomField9,    
         CustomField10    
 FROM   dbo.' + @TableName + ' Join #ItemSelect ON ' + @TableName + '.ItemStoreID = #ItemSelect.ItemStoreID '     
    
IF (Select COUNT(*) from SetUpValues where OptionID = 100 and ((OptionValue = '1') or(OptionValue = 'True')) And StoreID <> '00000000-0000-0000-0000-000000000000') >0    
set @MyGroup = '    
    
 GROUP BY   '+@TableName+'.ItemStoreID,    
          Name,    
    Groups,    
    ParentName,    
    Color,    
    Size,    
          ModalNumber,     
          BarcodeNumber,    
            ItemTypeName,     
                Department,    
    DepartmentID,    
    MainDepartment,    
    SubDepartment,    
    SubSubDepartment,    
    StyleNo,    
          Supplier,    
          SupplierCode,    
    Brand,    
    CustomerCode,    
       StoreName,    
    StoreID,    
    ParentCode,    
                ItemID,    
    ParentSupplerName,    
    LastReceivedDate,    
    LastReceivedQty,    
    CustomField1,    
    CustomField2,    
    CustomField3,    
    CustomField4,    
    CustomField5,    
    CustomField6,    
    CustomField7,    
    CustomField8,    
    CustomField9,    
    CustomField10    
        
    '    
Else    
set @MyGroup = '    
    
 GROUP BY   '+@TableName+'.ItemStoreID,    
          Name,    
    Groups,    
    ParentName,    
    Color,    
    Size,    
          ModalNumber,     
          BarcodeNumber,    
            ItemTypeName,     
                Department,    
    DepartmentID,    
    StyleNo,    
    Supplier,    
          SupplierCode,    
    Brand,    
    CustomerCode,    
       StoreName,    
    StoreID,    
    ParentCode,    
                ItemID,    
    ParentSupplerName,    
    LastReceivedDate,    
    LastReceivedQty,    
    CustomField1,    
    CustomField2,    
    CustomField3,    
    CustomField4,    
    CustomField5,    
    CustomField6,    
    CustomField7,    
    CustomField8,    
    CustomField9,    
    CustomField10    
    '    
    
--print 1    
--Print   ( @ItemSelect + @ItemFilter + @MySelect + @TableName + @MyWhere + @Filter +@MyGroup  )    
--print 1    
PRINT (COALESCE(@ItemSelect,'') + COALESCE(@ItemFilter,'') + COALESCE(@CustomerSelect,'') +   
COALESCE(@CustomerFilter,'') + COALESCE(@MySelect,'')   
+ COALESCE(@MyWhere,'') + COALESCE(@Filter,'') +   
COALESCE(@MyGroup,'') )    
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter +@MyGroup )    
    
    
if object_id ('tempdb..#ItemSelect') is not null drop table #ItemSelect    
if @CustomerFilter<>''    
drop table #CustomerSelect
GO