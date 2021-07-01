SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetQtySaleByDates]
(@Date1 datetime,
@Date2 datetime,
@Filter Nvarchar(4000),
@ItemFilter Nvarchar(4000),
@CustomerFilter Nvarchar(4000),
@TableName nvarchar(100))

AS 

declare @ItemSelect nvarchar(4000)
declare @CustomerSelect nvarchar(4000)
Declare @MySelect  Nvarchar(4000)
Declare @MyWhere nvarchar(4000)
Declare @GroupBy nvarchar(4000)
Declare @Dates nvarchar(4000)

set @CustomerSelect=''

Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

if @CustomerFilter<>''

	begin 
		Set  @CustomerSelect='Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where (1=1) And  exists (Select 1 From #CustomerSelect where CustomerID='+@TableName+'.CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where (1=1)  '


Set @Dates ='''' + Convert(nvarchar,@Date1,120) + '''' + ',' + '''' + Convert(nvarchar,@Date2,120)+ '''' 

Set @MySelect =	'SELECT     Name AS Name,
			                ItemStoreID, 	
		                    ModalNumber,
							ParentCode,
			                BarcodeNumber,
							ItemID,
							StoreName,
							Department,
                            SUM(Qty) AS Qty,
			                SUM(Total) AS Total,
                            (SELECT CASE WHEN DATEDIFF(week, ' + @Dates + ') = 0 THEN SUM(Qty) 
				                    ELSE SUM(Qty) / DATEDIFF(week,' + @Dates + ') 
		            END) AS SalesPerWeek,

                           (SELECT CASE WHEN DATEDIFF(month,' + @Dates + ') = 0 THEN SUM(Qty) 
                                  ELSE SUM(Qty) / DATEDIFF(month,' + @Dates + ') 
		            END) AS SalesPerMonth,

                           (SELECT CASE WHEN DATEDIFF(Year,' + @Dates + ') = 0 THEN SUM(Qty) 
				  ELSE SUM(Qty) / DATEDIFF(Year,' + @Dates + ') 
		            END) AS SalesPerYear,
                     
			   (SELECT CASE WHEN DATEDIFF(week,' + @Dates + ') = 0 THEN SUM(Total) 
				  ELSE SUM(Total) / DATEDIFF(week,' + @Dates + ') 
		            END) AS PricePerWeek,

                           (SELECT CASE WHEN DATEDIFF(month,' + @Dates + ') = 0 THEN SUM(Total) 
                                  ELSE SUM(Total) / DATEDIFF(month, ' + @Dates + ') 
		            END) AS PricePerMonth,

                           (SELECT CASE WHEN DATEDIFF(Year,' + @Dates + ') = 0 THEN SUM(Total) 
				  ELSE SUM(Total) / DATEDIFF(Year,' + @Dates + ') 
		            END) AS PricePerYear,
					StoreID,
                    max('+@TableName+'.Price) as Price,
                    max('+@TableName+'.OnHand) as OnHand
                     
					FROM      
        ' +@TableName+ ' INNER JOIN #ItemSelect ON '+@TableName+'.ItemStoreID = #ItemSelect.ItemStoreID '

Set @GroupBy = ' GROUP BY ItemStoreID,
						  Department,
			              Name, 
			              ItemID, 
                          ModalNumber,
			              BarcodeNumber,
						  ParentCode,
			              StoreID,
						  StoreName '

print   (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @GroupBy)            
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @GroupBy)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO