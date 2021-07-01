SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemMainAndStoreGrid]
(
@StoreID uniqueidentifier,
@Stores Guid_list_tbltype READONLY ,
@DeletedOnly bit =0,
@DateModified datetime=null,
@FromStatus as Int = -1,
@ID uniqueidentifier=null,
@PageIndex int = 0,
@NumRows Int = 100000,
@Filter nvarchar(4000)='',
@refreshTime  datetime output)
AS
 DECLARE @Select nvarchar(max),@Select1 nvarchar(max) ,@Select2 nvarchar(max) 
 DECLARE @F  nvarchar(2000) =''
 DECLARE @sStoreID  nvarchar(60),@sDate nvarchar(20)
 SET @sStoreID  =@StoreID 
 print @StoreID
if @DateModified is not null  
   SET @sDate  =''''+dbo.FormatDateTime(@DateModified,'YYYY-MM-DD')+' '+dbo.FormatDateTime(@DateModified,'HH:MM 24')+''''

 IF @Filter <>''
   SET @F= @Filter   
 set @refreshTime = dbo.GetLocalDATE()

DECLARE @startRowIndex INT
SET @startRowIndex = (@PageIndex * @NumRows)+1;
IF @ID IS NOT NULL
BEGIN 
	   SELECT     dbo.ItemMainAndStoreView.*
	   FROM         dbo.ItemMainAndStoreView
	   WHERE     (Status >@FromStatus ) AND (StoreNo = @StoreID)AND(ItemStoreID=@ID) AND (ItemStoreDateModified>=isnull(@DateModified,ItemStoreDateModified)  OR MainDateModified >=isnull(@DateModified,MainDateModified) OR DepartmentDateModified >=isnull(@DateModified,DepartmentDateModified)
                                   OR GroupDateModified>=isnull(@DateModified,GroupDateModified))
   RETURN
END 
--print 55
if @DateModified is null 
begin
     SET @Select1 ='SELECT  * FROM Page WHERE Row BETWEEN '+CONVERT(nvarchar, @startRowIndex, 110)+'  AND '+CONVERT(nvarchar, @StartRowIndex+ @NumRows-1, 110) 

	 print @Select1
	 print  1565465456
	--  set @Select='as'
	  --print @Select
	  -- print @StoreID
	 --  print @FromStatus
	 set @Select ='With Page as (	SELECT     ROW_NUMBER() OVER (Order By DateCREATEd Asc) AS Row, 
		         allItems.*
from (

select
SUM(onhand) OVER(PARTITION BY itemid) AS TotalOnHand,
SUM(MTD) OVER(PARTITION BY itemid) AS TotalMTD,
SUM(YTD) OVER(PARTITION BY itemid) AS TotalYTD,
SUM(PTD) OVER(PARTITION BY itemid) AS TotalPTD,
SUM("MTD Pc Qty") OVER(PARTITION BY itemid) AS TotalMTDQty,
SUM("YTD Pc Qty") OVER(PARTITION BY itemid) AS TotalYTDQty,
SUM("PTD Pc Qty") OVER(PARTITION BY itemid) AS TotalPTDQty,
SUM(OnOrder) OVER(PARTITION BY itemid) AS TotalOnOrder,
SUM(OnTransferOrder) OVER(PARTITION BY itemid) AS TotalOnTransferOrder,
SUM(CsOnHand) OVER(PARTITION BY itemid) AS TotalCsOnHand,
ItemMainAndStoreGrid.*
from ItemMainAndStoreGrid
where 1=1
and StoreNo in (select n from  @Stores )
)allItems
			
			WHERE  (StoreNo = '''+CONVERT(varchar(100),@StoreID)+''') 
			
			AND   
			 (Status> '+CONVERT(varchar(10), @FromStatus)+') AND (MainStatus>-1)'

			 print @Select
			  print 111
			-- print @Select1
			  set @Select2 = @Select +@F +')'+  @Select1
			  print 'f' + @F
			   print @Select2
			 exec sp_executesql @query=@Select2, @params=N'@Stores Guid_list_tbltype READONLY ', @Stores=@Stores
			
     -- exec(@Select +@F +')'+  @Select1)  
                         
	  SET @RefreshTime = dbo.GetLocalDATE()  
      return  set @refreshTime = dbo.GetLocalDATE()

end 


if  @DeletedOnly=1 
BEGIN 
 set @Select =' With Page as (SELECT     ROW_NUMBER() OVER (Order By DateCREATEd Asc) AS Row, 
		         dbo.ItemMainAndStoreView.ItemStoreID 
			FROM         dbo.ItemMainAndStoreView
			WHERE  (StoreNo = '''+@sStoreID+''') AND   (Status> 0) AND (MainStatus>-1)'--)
SET @Select1 ='	SELECT     Page.Row ,ItemMainAndStoreView.*
            FROM  ItemMainAndStoreView INNER JOIN Page ON ItemMainAndStoreView.ItemStoreID = Page.ItemStoreID  
            WHERE Row BETWEEN '+CONVERT(nvarchar, @startRowIndex, 110)+'  AND '+CONVERT(nvarchar, @StartRowIndex+ @NumRows-1, 110)+' AND    	
			(StoreNo = '''+@sStoreID+''') AND   
			(ItemStoreDateModified>='+@sDate+'  OR MainDateModified >='+@sDate+' OR DepartmentDateModified >='+@sDate+' OR GroupDateModified>='+@sDate+')AND 
	        (Status> '+CONVERT(nvarchar, @FromStatus, 110)+')'
  --exec(@Select +@F )
   exec(@Select +@F +')'+  @Select1)  
   --print @Select +@F +')'+  @Select1 
   return  set @refreshTime = dbo.GetLocalDATE()

			
END
ELSE 
BEGIN

	
select allItems.*
from (

select
SUM(onhand) OVER(PARTITION BY itemid) AS TotalOnHand,
SUM(MTD) OVER(PARTITION BY itemid) AS TotalMTD,
SUM(YTD) OVER(PARTITION BY itemid) AS TotalYTD,
SUM(PTD) OVER(PARTITION BY itemid) AS TotalPTD,
SUM("MTD Pc Qty") OVER(PARTITION BY itemid) AS TotalMTDQty,
SUM("YTD Pc Qty") OVER(PARTITION BY itemid) AS TotalYTDQty,
SUM("PTD Pc Qty") OVER(PARTITION BY itemid) AS TotalPTDQty,
SUM(OnOrder) OVER(PARTITION BY itemid) AS TotalOnOrder,
SUM(OnTransferOrder) OVER(PARTITION BY itemid) AS TotalOnTransferOrder,
SUM(CsOnHand) OVER(PARTITION BY itemid) AS TotalCsOnHand,
ItemMainAndStoreGrid.*
from ItemMainAndStoreGrid
where 1=1
and StoreNo in (select n from  @Stores)
--and itemid ='0094E9C2-A346-44DB-93BF-0000483CC1B9'
)allItems
where StoreNo  =@StoreID
	AND (ItemStoreDateModified>=@DateModified  OR MainDateModified >=@DateModified OR DepartmentDateModified >=@DateModified
	                                       OR GroupDateModified>=@DateModified)
                AND  (MainStatus= - 1   OR  Status = - 1)
 Print 'ELSE BEGIN'
                
END
GO