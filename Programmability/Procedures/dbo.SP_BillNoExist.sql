SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Erenthal>
-- Create date: <5/17/2010>
-- Description:	<Check If the bill No exist in other Receive Order with the same supplier>
-- =============================================

CREATE procedure [dbo].[SP_BillNoExist]
(@SupplierNo uniqueidentifier,
 @ReceiveID uniqueidentifier,
 @BillNo NvarChar(30))
as 
select count(*) from dbo.ReceiveOrderView 
where BillNo =@BillNo
and SupplierNo=@SupplierNo
and ReceiveID<>@ReceiveID
And Status> 0
GO