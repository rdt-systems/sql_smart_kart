SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[WEB_GetSearchResultWithBind]

(@Key nvarchar(50),
@Dep nvarchar(50)=null,
@PriceFrom decimal=null,
@PriceTo decimal=null,
@Gemstonen varchar(50)=null,
@ItemCount int output,
@PageIndex int,
 @NumRows INT =-1
)

AS 
--DECLARE @startRowIndex INT;
--    SELECT @ItemCount=(SELECT COUNT(*) FROM itemmainandstoreview as ISell_items
--inner join dbo.itemmainandstoreview SL on ISell_items.BarcodeNumber collate HEBREW_CI_AS=SL.BarcodeNumber collate HEBREW_CI_AS 
--								and SL.onhand>0 and SL.status>0 



--            where  (ISell_items.[name] like '%'+@Key+ '%'
--or ISell_items.[description] like '%'+@Key+ '%'  or ISell_items.department like '%' +@Key+ '%'  or ISell_items.groups like '%'+@Key+ '%' 
--or ISell_items.barcodenumber like '%'+@Key+ '%')
--and (ISell_items.department like '%'+@Dep+ '%' or @Dep is null ) and (ISell_items.price between @PriceFrom and @PriceTo or @PriceFrom is null)
--and(ISell_items.[description] like '%'+@Gemstonen+ '%' or ISell_items.groups like '%'+@Gemstonen+ '%' or @Gemstonen is null )
--and ISell_items.status>0 and
--(ISell_items.itemtype=2 or ISell_items.itemtype =0))

--if  @NumRows=-1  
-- set @NumRows=@ItemCount
 
--SET    @startRowIndex = (@PageIndex * @NumRows)+1 ;

-- With ItemsPage as (
--                        SELECT     ROW_NUMBER() OVER (ORDER BY ISell_items.BarcodeNumber ASC) AS Row,
--                        ISell_items.[name],ISell_items.price,ISell_items.[description],ISell_items.ItemStoreID,ISell_items.ItemID,ISell_items.BarcodeNumber
--                        FROM         itemmainandstoreview as ISell_items

--								inner join testsilverline.dbo.itemmainandstoreview SL on SL.BarcodeNumber collate HEBREW_CI_AS=ISell_items.BarcodeNumber  collate HEBREW_CI_AS
--								and SL.onhand>0 and SL.status>0 
--            where  (ISell_items.[name] like '%'+@Key+ '%'
--or ISell_items.[description] like '%'+@Key+ '%'  or ISell_items.department like '%' +@Key+ '%'  or ISell_items.groups like '%'+@Key+ '%' 
--or ISell_items.barcodenumber like '%'+@Key+ '%')
--and (ISell_items.department like '%'+@Dep+ '%' or @Dep is null ) and (ISell_items.price between @PriceFrom and @PriceTo or @PriceFrom is null)
--and(ISell_items.[description] like '%'+@Gemstonen+ '%' or ISell_items.groups like '%'+@Gemstonen+ '%' or @Gemstonen is null )
--and ISell_items.status>0 and
--(ISell_items.itemtype=2 or ISell_items.itemtype =0) )
   
--     SELECT     [name], price, [description],ItemStoreID,ItemID,BarcodeNumber
--     FROM         ItemsPage
--     WHERE     Row BETWEEN @startRowIndex AND @StartRowIndex + @NumRows-1
GO