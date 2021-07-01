SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetSearchChildWithBind]

(@Key nvarchar(50),
@Dep nvarchar(50)=null,
@PriceFrom decimal=null,
@PriceTo decimal=null,
@Gemstonen varchar(50)=null,
@PageIndex int,
 @NumRows INT =-1
)

AS 
DECLARE @startRowIndex INT;
    
SET    @startRowIndex = (@PageIndex * @NumRows)+1 ;

  
		SELECT   Row ,	matrix1, linkno,ItemStoreID,Price
		into #ItemsPage
                   FROM (
						SELECT   Row ,matrix.matrix1, matrix.linkno,matrix.ItemStoreID,matrix.price
						FROM (
							SELECT ROW_NUMBER() OVER (ORDER BY i.BarcodeNumber ASC) AS Row,i.linkno,i.matrix1,i.itemstoreid,i.Price,i.itemid
						    FROM itemmainandstoreview  i
 						inner join dbo.itemmainandstoreview SL on SL.barcodenumber collate HEBREW_CI_AS=i.barcodenumber collate HEBREW_CI_AS
				and SL.onhand>0 and SL.status>0 
						    WHERE      i.status>0 and (i.itemtype=0 or i.itemtype=2)  and
							 ( i.[name] like '%'+@Key+ '%'
							 or i.Name like '%'+@Key+ '%'  or i.department like '%' +@Key+ '%' 
							 or i.groups like '%'+@Key+ '%' or i.barcodenumber like '%'+@Key+ '%')
							 and (i.department like '%'+@Dep+ '%' or @Dep is null ) 
							 and (i.price between @PriceFrom and @PriceTo or @PriceFrom is null)
							 and(i.Name like '%'+@Gemstonen+ '%' or 
							 i.groups like '%'+@Gemstonen+ '%' or @Gemstonen is null) 
                             )AS ISell_items
							INNER JOIN itemmainandstoreview AS matrix ON 
									ISell_items.itemid=matrix.linkno and matrix.linkno is not null and matrix.status>0
									and matrix.itemtype=1 
							inner join dbo.itemmainandstoreview SL on SL.barcodenumber collate HEBREW_CI_AS=matrix.barcodenumber collate HEBREW_CI_AS
										and SL.onhand>0 and SL.status>0 
							)as a
			
						
  if @NumRows<>-1
     SELECT     Matrix1,LinkNo,ItemStoreID,Price
     FROM         #ItemsPage
     WHERE     Row BETWEEN @startRowIndex AND @StartRowIndex + @NumRows-1
     order by matrix1
else
     SELECT     Matrix1,LinkNo,ItemStoreID,Price
     FROM         #ItemsPage
     order by matrix1
GO