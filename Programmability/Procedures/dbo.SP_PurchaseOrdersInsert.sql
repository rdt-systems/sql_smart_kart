SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrdersInsert]
(@PurchaseOrderId uniqueidentifier,
@SupplierNo uniqueidentifier,
@StoreNo uniqueidentifier,
@PoNo nvarchar(50),
@PersonOrderdId uniqueidentifier,
@ShipVia uniqueidentifier,
@ShipTo nvarchar (4000),
@TrackNo nvarchar(50),
@ReqDate datetime,
@ExpirationDate datetime,
@TermsNo uniqueidentifier,
@Shipdrop bit, 
@Reorder bit =0,
@Note nvarchar(4000),
@PurchaseOrderDate datetime,
@GrandTotal money,
@POStatus Int,
@TermsID	uniqueidentifier = NULL,
@BuyerID	uniqueidentifier = NULL,
@BillToStoreID	uniqueidentifier =NULL,
@VendorPONo	nvarchar(100) = NULL,
@DepartmentID	uniqueidentifier = NULL,
@SeasonID	uniqueidentifier = NULL,
@ClassID  uniqueidentifier = NULL,
@MinMarkup decimal(18, 4) = NULL,
@ListPrice decimal (18, 4) = NULL,
@Import smallint = NULL,
@Sent bit = NULL,
@Approved bit = NULL,

@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.PurchaseOrders
                      (PurchaseOrderId, SupplierNo, StoreNo, PoNo, PersonOrderdId, ShipVia, ShipTo, TrackNo, ReqDate, ExpirationDate, TermsNo,Shipdrop, POStatus,Reorder, GrandTotal, 
                      Note, PurchaseOrderDate, Status, DateCreated, UserCreated, DateModified, UserModified, TermsID, BuyerID, BillToStoreID, VendorPONo,DepartmentID,SeasonID, ClassID, MinMarkup, ListPrice, Import,Sent, Approved)
VALUES     (@PurchaseOrderId, @SupplierNo, @StoreNo, @PoNo, @PersonOrderdId, @ShipVia, @ShipTo, @TrackNo, @ReqDate, @ExpirationDate, @TermsNo, @Shipdrop,
                      0,@Reorder, @GrandTotal, @Note, @PurchaseOrderDate, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID, @TermsID, @BuyerID, @BillToStoreID, @VendorPONo,@DepartmentID,@SeasonID,@ClassID, @MinMarkup, @ListPrice, @Import, @Sent, @Approved)
GO