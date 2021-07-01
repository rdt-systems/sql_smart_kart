SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrdersUpdate]
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
@POStatus Int,
@Reorder bit =0,
@GrandTotal  money,
@Note nvarchar(4000),
@PurchaseOrderDate datetime,
@TermsID	uniqueidentifier = NULL,
@BuyerID	uniqueidentifier = NULL,
@BillToStoreID	uniqueidentifier =NULL,
@VendorPONo	nvarchar(100) = NULL,
@DepartmentID	uniqueidentifier = NULL,
@SeasonID	uniqueidentifier = NULL,
@ClassID	uniqueidentifier = NULL,
@MinMarkup decimal(18, 4) = NULL,
@ListPrice decimal (18, 4) = NULL,
@Import smallint = NULL,
@Sent bit = NULL,
@Approved bit = NULL,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE       PurchaseOrders
SET                SupplierNo = @SupplierNo, StoreNo = @StoreNo, PoNo = @PoNo, PersonOrderdId = @PersonOrderdId, ShipVia = @ShipVia, ShipTo = @ShipTo, TermsID = @TermsID, BuyerID = @BuyerID, 
                         BillToStoreID = @BillToStoreID, VendorPONo = @VendorPONo, DepartmentID = @DepartmentID, SeasonID = @SeasonID, TrackNo = @TrackNo, ReqDate = @ReqDate, ExpirationDate = @ExpirationDate, 
                         TermsNo = @TermsNo, Shipdrop = @Shipdrop, POStatus = @POStatus, Reorder = @Reorder, GrandTotal = @GrandTotal, Note = @Note, PurchaseOrderDate = @PurchaseOrderDate, Status = @Status, ClassID = @ClassID,
						 MinMarkup = @MinMarkup, ListPrice = @ListPrice, Import = @Import, Sent = @Sent, Approved = @Approved,
                         DateModified = @UpdateTime, UserModified = @modifierID
WHERE        (PurchaseOrderId = @PurchaseOrderId)
--AND (DateModified = @DateModified OR
--                      DateModified IS NULL)
GO