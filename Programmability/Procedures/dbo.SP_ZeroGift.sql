SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ZeroGift]
(@GiftID uniqueidentifier,
@ModifierID uniqueidentifier = NULL
)
AS
DECLARE @Note nvarchar(1000)
set @Note =(SELECT Notes FROM Coupon WHERE  CouponID  = @GiftID)
IF ISNULL(@Note,'')<>''
BEGIN
  SET @Note =@Note + CHAR(13)+CHAR(10)+' '
END
SET @Note =@Note +'Zeroed In Back Office,'
Update Coupon Set Notes =@Note , DateModified =dbo.GetLocalDATE() , UserModified = @ModifierID
WHERE  CouponID  = @GiftID

declare @cBal money
set @cBal = (SELECT Coupon.Amount - IsNull(Used.AmountUsed,0) FROM Coupon LEFT OUTER JOIN
                             (SELECT  SUM(Amount) AS AmountUsed, CouponID
                               FROM   CouponUsed WHERE (Status > 0)  GROUP BY CouponID) AS Used ON Coupon.CouponID = Used.CouponID where  Coupon.CouponID = @GiftID)

Insert Into [CouponUsed] (Amount,CouponID,CouponUsedID,DateCreated,Status,TransactionID,UsedDate,DateModified)
Values (@cBal,@GiftID,NEWID(),dbo.GetLocalDATE(),1,'00000000-0000-0000-0000-000000000000',dbo.GetLocalDATE(),dbo.GetLocalDATE())
GO