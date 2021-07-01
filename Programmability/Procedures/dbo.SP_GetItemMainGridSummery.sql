SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemMainGridSummery]
(
@StoreID uniqueidentifier,
@Stores Guid_list_tbltype READONLY,
@SoldType nvarchar(4000) = null,
@Days int =null ,
@Statid Int=null,
@UserId uniqueidentifier=null)
AS

if @Statid is not null
begin


DECLARE @startRowIndex INT 
DECLARE @PageIndex INT =0
DECLARE @NumRows INT=100000
SET @startRowIndex = (@PageIndex * @NumRows)+1;
 DECLARE @Select nvarchar(2000),@Select1 nvarchar(2000) 
  DECLARE @F  nvarchar(2000)=''

     SET @Select1 ='SELECT  *  FROM Page WHERE Row BETWEEN '+CONVERT(nvarchar, @startRowIndex, 110)+'  AND '+CONVERT(nvarchar, @StartRowIndex+ @NumRows-1, 110) 
	 set @Select ='With Page as (	SELECT     ROW_NUMBER() OVER (Order By DateCREATEd Asc) AS Row, 
		         dbo.ItemMainAndStoreGrid.*
			FROM         dbo.ItemMainAndStoreGrid
			WHERE  (StoreNo = '''+convert(varchar(50),@StoreID)+''') AND   
			 (Status> '+CONVERT(nvarchar, -1, 110)+') AND (MainStatus>-1)'
			 

if @Statid is not null

begin 
Create table #TempItems(ItemStoreId uniqueidentifier)
insert into #TempItems
exec [SP_RunGetStatsTblItems]  @StoreID =@StoreID ,@Statid=@Statid, @UserId=@UserId

set @select=@select +' and ItemStoreID in ( '+ 'select * from #TempItems)'
end

--  print @Select +@F +')'+  + @Select1      
  exec(@Select +@F +')'+  @Select1)  

end 


	else If (Select COUNT(1) From  @Stores) > 1
	begin 
	
select allItems.*
from (

select
SUM(onhand) OVER(PARTITION BY itemid) AS OnHand,
SUM(MTD) OVER(PARTITION BY itemid) AS MTD,
SUM(YTD) OVER(PARTITION BY itemid) AS YTD,
SUM(PTD) OVER(PARTITION BY itemid) AS PTD,
SUM("MTD Pc Qty") OVER(PARTITION BY itemid) AS "MTD_Pc_Qty",
SUM("YTD Pc Qty") OVER(PARTITION BY itemid) AS "YTD_Pc_Qty",
SUM("PTD Pc Qty") OVER(PARTITION BY itemid) AS "PTD_Pc_Qty",
SUM(OnOrder) OVER(PARTITION BY itemid) AS OnOrder,
SUM(OnTransferOrder) OVER(PARTITION BY itemid) AS OnTransferOrder,
SUM(CsOnHand) OVER(PARTITION BY itemid) AS CsOnHand,
 "Cs Cost" as Cs_Cost, "Future SP From" as Future_SP_From, "Future SP Price" as Future_SP_Price, "Future SP To" as Future_SP_To, "MTD Cs Qty" as MTD_Cs_Qty,  "Pc Cost" as Pc_Cost, "Pkg Price Margin" as Pkg_Price_Margin, "Pkg Price Markup" as Pkg_Price_Markup, "PTD Cs Qty" as PTD_Cs_Qty, "Reg SP Price Margin" as Reg_SP_Price_Margin, 
 "Reg SP Price Markup" as  Reg_SP_Price_Markup, "SP From" as SP_From, "SP Margin" as SP_Margin, "SP Markup" as SP_Markup, "SP Price" as  SP_Price, "SP To" as  SP_To, "Supplier Item Code" as Supplier_Item_Code, "YTD Cs Qty" as YTD_Cs_Qty, AVGCost, BarcodeNumber, BarcodeType, BinLocation, Brand, CaseBarcodeNumber, CasePrice, CaseQty, CaseSPPrice, Cost, CostByCase, CustomerCode, CustomInteger1, DateCreated, Department, DepartmentDateModified, DepartmentID, GroupDateModified, Groups, IsDiscount, IsFoodStampable, IsTaxable, IsWIC, ItemAlias, ItemID, ItemNo, ItemStoreDateModified, ItemStoreID, ItemType, ItemTypeName, LinkNo, ListPrice, ListPriceMarkup, MainDateModified, MainDepartment, MainStatus, MainSupplierID, ManufacturerPartNo, Margin, Markdown, Markup, Matrix1, Matrix2, Matrix3, Matrix4, Matrix5, Matrix6, MatrixTableNo, ModalNumber, Name, ParentCode, PrefOrderBy, PrefSaleBy, Price, PriceByCase, RegCost, RegPkgPrice, RegSPPrice, ReorderPoint, RestockLevel, SeasonName, Size, Status, StoreNo, StyleNo, SubDepartment, SubSubDepartment, SupplierName, ToReorder,extname,
CustomField1,CustomField2,CustomField3,CustomField4,CustomField5,CustomField6,CustomField7,CustomField8,CustomField9,CustomField10
from ItemMainAndStoreGrid
where 1=1
and StoreNo in (select n from  @Stores)
)allItems
where StoreNo  =@StoreID
 AND  (MainStatus>0   and  Status > 0)
 and ( @SoldType is null 

 or  ( @SoldType ='Sold'  and   exists (
			select 1
			from ItemExistsSales te 
 			where te.ItemStoreID=allItems.ItemStoreID
			and te.EndSaleTime > convert(date,DATEADD(d,@days*-1,dbo.getlocaldate()))))
or (@SoldType ='Not Sold' 	and not  exists (
			select 1
			from ItemExistsSales te 
 			where te.ItemStoreID=allItems.ItemStoreID
			and te.EndSaleTime > convert(date,DATEADD(d,@days*-1,dbo.getlocaldate())))))

			end

			Else
			begin
Select * from ItemMainAndStoreGrid AS  allItems
where 1=1
and StoreNo  =@StoreID
 AND  (MainStatus>0   and  Status > 0)
 and ( @SoldType is null 

 or  ( @SoldType ='Sold'  and   exists (
			select 1
			from ItemExistsSales te 
 			where te.ItemStoreID=allItems.ItemStoreID
			and te.EndSaleTime > convert(date,DATEADD(d,@days*-1,dbo.getlocaldate()))))
or (@SoldType ='Not Sold' 	and not  exists (
			select 1
			from ItemExistsSales te 
 			where te.ItemStoreID=allItems.ItemStoreID
			and te.EndSaleTime > convert(date,DATEADD(d,@days*-1,dbo.getlocaldate())))))

			end
			
--exec [SP_GetItemMainGridSummery] @StoreID ='308b80a6-ea16-41ef-928b-fa5ff0c17dd5' ,@Statid=4, @UserId='d224f3ea-717a-4d96-9215-98664579974c'
GO