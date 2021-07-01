SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DeletePaymentsByBill]
(@ReceiveID uniqueidentifier,@ModifierID uniqueidentifier)


as
SELECT       dbo.PayToBillView.PayToBillID
into #Table1  
FROM      dbo.PayToBillView INNER JOIN
          dbo.BillView ON dbo.PayToBillView.BillID = dbo.BillView.BillID 
WHERE     (dbo.BillView.BillID = @ReceiveID and dbo.PayToBillView.Status>0 )

Update  dbo.PayToBill
SET Status = -1 , dateModified =   dbo.GetLocalDATE(),   UserModified  = @ModifierId
where exists (Select PayToBillID from #Table1 where PayToBillID=PayToBill.PayToBillID)


SELECT        dbo.ReturnToVender.ReturnToVenderID 
into #Table2
FROM         dbo.Bill INNER JOIN
                      dbo.PayToBill ON dbo.Bill.BillID = dbo.PayToBill.BillID INNER JOIN
                      dbo.ReturnToVender ON dbo.PayToBill.SuppTenderID = dbo.ReturnToVender.ReturnToVenderID
WHERE     (dbo.Bill.BillID = @ReceiveID and dbo.PayToBill.Status>0)


UPDATE dbo. ReturnToVender
SET   Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE exists  (Select ReturnToVenderID from #Table2 where ReturnToVenderID=ReturnToVender.ReturnToVenderID)

drop table #Table1
drop table #Table2

--Update Bill
--Set AmountPay=0,DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
--where BillID=@ReceiveID
GO