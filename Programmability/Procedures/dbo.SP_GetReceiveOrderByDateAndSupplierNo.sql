SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[SP_GetReceiveOrderByDateAndSupplierNo]
(@ReceiveOrderDate datetime,
@SupplierNo uniqueidentifier)

AS 


begin

 SELECT    top 1  dbo.ReceiveOrder.*
 FROM         dbo.ReceiveOrder
 WHERE     (Status > - 1) 
 and convert(date,[ReceiveOrderDate] ) =convert(date,@ReceiveOrderDate )
 and SupplierNo=@SupplierNo

return
end
GO