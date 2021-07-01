SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOnHandPivot](@ParentID uniqueidentifier ,@StoreID uniqueidentifier =null)
AS 


DECLARE @cols AS NVARCHAR(4000),
    @query  AS NVARCHAR(4000),
    @colsPivot AS NVARCHAR(4000)

select  @colsPivot = 
  STUFF((SELECT distinct ', sum( ' + QUOTENAME(sss.size) +') as ['+ sss.size+']' 
                    from (          SELECT        ItemMain.Matrix1 as color, ItemMain.Matrix2 as size, SUM(ItemStore.OnHand) AS Onhand
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
WHERE        (ItemMain.LinkNo = @ParentID) AND (ItemStore.Status > 0)
GROUP BY ItemMain.Matrix1, ItemMain.Matrix2) as sss
					where 1=1
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


select @cols = 
  STUFF(
  (SELECT distinct ', ' + QUOTENAME(sss.size)  
                   
from (
SELECT        ItemMain.Matrix1 as color, ItemMain.Matrix2 as size, SUM(ItemStore.OnHand) AS Onhand
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
WHERE        (ItemMain.LinkNo = @ParentID) AND (ItemStore.Status > 0)
GROUP BY ItemMain.Matrix1, ItemMain.Matrix2
) as sss
					where 1=1
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @colsPivot
		print @cols
set @query =
       'SELECT Color,' + @colsPivot + '  
         from (
SELECT        ItemMain.Matrix1 as color  , ItemMain.Matrix2 as size, SUM(ItemStore.OnHand) AS Onhand
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
WHERE        (ItemMain.LinkNo = '''+convert(nvarchar(4000), @ParentID)+''') AND (ItemStore.Status > 0) '

if (@StoreID is not null  )  
 set  @query =@query+ 
' and ItemStore.StoreNo ='''+convert(nvarchar(4000),@StoreID)+'''' ;
  
  set @query = @query+
' GROUP BY ItemMain.Matrix1, ItemMain.Matrix2
         ) x
         pivot 
         (
            sum(Onhand)
            for size in (' + @cols + ')
         ) p
		 group by color '

		 print (@query)
execute(@query)
GO