SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOneBill]
(@BillID uniqueidentifier = null,
 @ReceiveID uniqueidentifier= null)
as

if @BillID is null
Set @BillID=(select BillID from ReceiveOrderView where ReceiveID=@ReceiveID)

	SELECT     dbo.BillView.*
	FROM       dbo.BillView
	WHERE     (Status > - 1) and (BIllID=@BillID)
GO