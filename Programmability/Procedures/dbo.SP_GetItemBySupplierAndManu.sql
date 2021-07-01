SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemBySupplierAndManu]  
(@FilterS nvarchar(4000)='', @FilterM nvarchar(4000)='')AS
declare @MySelect nvarchar(4000),@MySelect2 nvarchar(4000)
if @FilterS<>'' and @FilterM <>''
begin
	set @MySelect=
	'select ItemMain.ItemID,ItemMain.[name]as Name from ItemMain INNER JOIN
	                      dbo.ItemMainAndStoreView ON dbo.ItemMain.ItemID = dbo.ItemMainAndStoreView.ItemID and dbo.ItemMainAndStoreView.Status=1
	where  ItemMain.Status=1 and  exists(select 1 from itemSupply where itemStoreNo=ItemMainAndStoreView.itemStoreID and 
	supplierNo in'
	set @MySelect2=
	'and exists (select 1 from manufacturers where manufacturerID=ItemMain.manufacturerID
	and manufacturerID in' 
	exec(@MySelect+@FilterS+')'+@MySelect2+@FilterM+')')
end
else
if @FilterM=''
begin
	set @MySelect=
	'select  ItemMain.ItemID,ItemMain.[name]as Name from ItemMain INNER JOIN
	                      dbo.ItemMainAndStoreView ON dbo.ItemMain.ItemID = dbo.ItemMainAndStoreView.ItemID and dbo.ItemMainAndStoreView.Status=1
	where  ItemMain.Status=1 and  exists(select 1 from itemSupply where itemStoreNo=ItemMainAndStoreView.itemStoreID and 
	supplierNo in '
	exec(@MySelect+@FilterS+')')
end
else
begin 

	set @MySelect=
	'select ItemMain.ItemID,ItemMain.[name]as Name  from ItemMain INNER JOIN
	                      dbo.ItemMainAndStoreView ON dbo.ItemMain.ItemID = dbo.ItemMainAndStoreView.ItemID and dbo.ItemMainAndStoreView.Status=1
	where   ItemMain.Status=1 and exists (select 1 from manufacturers where manufacturerID=ItemMain.manufacturerID
	and manufacturerID in' 
	exec(@MySelect+@FilterM+')')

end
GO