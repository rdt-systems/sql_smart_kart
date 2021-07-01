SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveOrderInsert_HandHeld]
(
@ReceiveID uniqueidentifier,
@StoreID uniqueidentifier,
@SupplierNo uniqueidentifier,
@Total money,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.ReceiveOrder
           (ReceiveID,StoreID,SupplierNo,Total,UserModified)
VALUES     (@ReceiveID,@StoreID,@SupplierNo,@Total,@ModifierID)
GO