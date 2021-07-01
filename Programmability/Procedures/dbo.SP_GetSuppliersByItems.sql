SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSuppliersByItems]
(@Filter nvarchar(4000)='')AS
declare @MySelect nvarchar(4000)


begin
set @MySelect=
	'select distinct SupplierID,Supplier.[name]as Name from Supplier
	where Supplier.status=1 and exists (select * from ItemSupply where supplierno=SupplierId  and status >-1
	and ItemStoreNo in'

if @Filter<>'' 
exec(@MySelect+@Filter+')')
end
GO