SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetGenOrders]

(
@Filter varchar (8000),
@IsMainStore bit
)

AS
						--Before loading will fill any missing main vendor
						UPDATE GenPurchaseOrder set Supplier = ItemSupply.SupplierNo
						FROM GenPurchaseOrder g INNER JOIN
                        ItemStore ON g.ItemNo = ItemStore.ItemStoreID INNER JOIN
                        ItemSupply ON ItemStore.MainSupplierID = ItemSupply.ItemSupplyID
						WHERE g.Supplier is null 
						--End filling vendor.

declare @Select nvarchar(40)

	if @IsMainStore = 1 
	Begin
		--declare @MainStoreID uniqueidentifier
		--set @MainStoreID = (select top(1) StoreID from Store where IsMainStore = 1 and Status > 0)

		Set @Select = 'SELECT * FROM GenOrderViewAllStore '
		print '@IsMain=1 ' + @Select + @Filter
		exec (@Select + @Filter)
	end

	else if @IsMainStore  = 0 Begin

		Set @Select = 'SELECT * FROM GenOrderView '

		print '@IsMain=0 ' + @Select + @Filter
		exec (@Select + @Filter)
	end
GO