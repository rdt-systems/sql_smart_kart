SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierUpdate]
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
@Note nvarchar(50)=null,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@MinMarkup decimal(18,4)=0,
@BuyerID uniqueidentifier=null,
@Department uniqueidentifier,
@ListPrice decimal(18,4)=0,
@Import smallint
)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.Supplier
SET              SupplierNo = @SupplierNo, [Name] = dbo.CheckString(@Name), DefaultCredit = @DefaultCredit, WebSite = @WebSite, EmailAddress = @EmailAddress, 
                      MainAddress = @MainAddress, ContactName = dbo.CheckString(@ContactName), BarterID = @BarterID,WarehouseID=@WarehouseID,AccountNo=@AccountNo, Status = @Status, DateModified = @UpdateTime, 
                      UserModified = @ModifierID,MinMarkup=@MinMarkup, BuyerID=@BuyerID, ListPrice=@ListPrice, Department=@Department, Import=@Import
WHERE     (SupplierID = @SupplierID) AND (DateModified = @DateModified OR
                      DateModified IS NULL)

select @UpdateTime as DateModified
GO