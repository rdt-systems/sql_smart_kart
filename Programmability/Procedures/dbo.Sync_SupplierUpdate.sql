SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_SupplierUpdate]
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
@DateModified datetime=null,
@ModifierID uniqueidentifier
)
as

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.Supplier
SET
	   SupplierNo = @SupplierNo,
       [Name] = @Name,
	   DateModified=@UpdateTime,
	   UserModified=@ModifierID

WHERE SupplierID=@SupplierID



exec [Sync_UpdateSupplierAddress] @SupplierID,@Address1,@Address2,@City,@State,@Zip,@PhoneNumber,@ModifierID
GO