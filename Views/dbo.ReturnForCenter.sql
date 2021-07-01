SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE     VIEW [dbo].[ReturnForCenter]
AS
SELECT     ReturnToVenderID, ReturnToVenderNo, 2 AS Type, ReturnToVenderDate, Total, SupplierID, StoreNo,
isnull(Total-isnull((select Sum(Amount) from dbo.PayToBill where SuppTenderID=dbo.ReturnToVender.ReturnToVenderID),0),0) as status
,Status AS IsVoid
FROM         dbo.ReturnToVender
WHERE     (Status > -1)
GO