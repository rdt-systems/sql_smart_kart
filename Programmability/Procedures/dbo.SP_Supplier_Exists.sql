SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Supplier_Exists]
(@SupplierID uniqueidentifier,
@ID nvarchar(50)=null,
@Name nvarchar(50) =null)
As 

if  @ID is  not null
begin
     select Status from dbo.SupplierView
     where (SupplierNo = @ID) and (Status>-1) and (SupplierID<>@SupplierID)
end
   else
begin
      select Status from dbo.SupplierView
      where [Name] = @Name and (Status>-1) and (SupplierID<>@SupplierID)
end
GO