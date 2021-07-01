SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierInsert]
(@SupplierID uniqueidentifier,
@SupplierNo nvarchar(50),
@Name nvarchar(50),
@DefaultCredit uniqueidentifier,
@WebSite nvarchar(50),
@EmailAddress nvarchar(50),
@MainAddress uniqueidentifier,
@ContactName nvarchar(50),
@BarterID uniqueidentifier,
@WarehouseID uniqueidentifier,
@AccountNo nvarchar(50)='',
@Status smallint,
--@DateModified datetime = null,
@Note nvarchar (50),
@ModifierID uniqueidentifier,
@MinMarkup decimal(18,4)=0,
@BuyerID uniqueidentifier=null,
@Department uniqueidentifier,
@ListPrice decimal(18,4)=0,
@Import smallint
)


AS INSERT INTO dbo.Supplier
                      (SupplierID, SupplierNo, [Name], DefaultCredit, WebSite, EmailAddress, MainAddress, ContactName, BarterID,WarehouseID,AccountNo, Status, DateCreated, UserCreated, 
                      DateModified, UserModified,MinMarkup,BuyerID,Department,ListPrice,Import)
VALUES     (@SupplierID, @SupplierNo, dbo.CheckString(@Name), @DefaultCredit, @WebSite, @EmailAddress, @MainAddress,dbo.CheckString(@ContactName), @BarterID,@WarehouseID, @AccountNo,1, dbo.GetLocalDATE(), 
                      @ModifierID, dbo.GetLocalDATE(), @ModifierID,@MinMarkup,@BuyerID,@Department,@ListPrice,@Import)
GO