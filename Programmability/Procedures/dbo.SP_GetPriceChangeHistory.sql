SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPriceChangeHistory]
(@ItemStoreID uniqueidentifier,
 @PriceLevel nvarchar(15),
 @ItemID uniqueidentifier,
 @Stores Guid_list_tbltype READONLY
 )
AS 
Declare @SQL nvarchar(2000)
Declare @where nvarchar(500)



 IF not EXISTS ( Select 1 from @Stores) 
begin 
	Set @SQL = 'SELECT     PriceChangeHistory.OldPrice, PriceChangeHistory.NewPrice, PriceChangeHistory.Date, Users.UserName AS [User], PriceChangeHistory.PriceLevel, 
						  PriceChangeHistory.SP_Price, PriceChangeHistory.SaleType, PriceChangeHistory.SaleDate
	FROM         PriceChangeHistory LEFT OUTER JOIN
						  Users ON PriceChangeHistory.UserID = Users.UserId'
 
	set @where = ' WHERE      (dbo.PriceChangeHistory.ItemStoreID = ' + '''' + cast(@ItemStoreID as nvarchar(50)) + '''' + ')'

	if @PriceLevel <> ''
	Begin
		set @where = @where + ' and PriceChangeHistory.PriceLevel = ' + '''' + @PriceLevel + ''''
	End
end 
else
begin 
	Set @SQL = 'SELECT    store.StoreName, PriceChangeHistory.OldPrice, PriceChangeHistory.NewPrice, PriceChangeHistory.Date, Users.UserName AS [User], PriceChangeHistory.PriceLevel, 
							  PriceChangeHistory.SP_Price, PriceChangeHistory.SaleType, PriceChangeHistory.SaleDate
		FROM         PriceChangeHistory 
		                  inner join itemstore
						  on itemstore.itemStoreid=PriceChangeHistory.itemstoreid
						   inner join store
						  on store.Storeid=itemstore.storeno
						  LEFT OUTER JOIN
							  Users ON PriceChangeHistory.UserID = Users.UserId'
 
		set @where = ' WHERE      (dbo.itemstore.ItemNo = ' + '''' + cast(@ItemID as nvarchar(50)) + '''' + ')'
		set @where = @where + ' and dbo.itemstore.StoreNo in (select n from  @Stores)'
		if @PriceLevel <> ''
		Begin
			set @where = @where + ' and PriceChangeHistory.PriceLevel = ' + '''' + @PriceLevel + ''''
		End

end

print @SQL + @where

set @SQL =@SQL+@where

exec sp_executesql @query=@SQL, @params=N'@Stores Guid_list_tbltype READONLY ', @Stores=@Stores
--exec (@SQL + @where )
GO