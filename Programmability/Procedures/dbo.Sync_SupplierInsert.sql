SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_SupplierInsert]
(
@SupplierID uniqueidentifier,
@SupplierNo nvarchar(50),
@Name nvarchar(50),
@Address1 nvarchar(50),
@Address2 nvarchar(50),
@City nvarchar(50),
@State nvarchar(50),
@Zip nvarchar(50),
@PhoneNumber nvarchar(50), 
@ModifierID uniqueidentifier,
@MinMarkup decimal(18,4)=0,
@BuyerID uniqueidentifier=null)

as


if (SELECT COUNT(*)
	FROM dbo.Supplier
	WHERE SupplierID=@SupplierID)>0 RETURN

INSERT INTO dbo.Supplier
                   
    (SupplierID,SupplierNo,[Name],Status, DateCreated, UserCreated, DateModified, UserModified,MinMarkup,BuyerID)

      

VALUES
    (@SupplierID,@SupplierNo,@Name,1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@MinMarkup,@BuyerID)

exec [Sync_UpdateSupplierAddress] SupplierID,@Address1,@Address2,@City,@State,@Zip,@PhoneNumber,@ModifierID
GO