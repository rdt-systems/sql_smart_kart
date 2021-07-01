SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetBillByNo]
(@No nvarchar(50))
As 


select * from Bill
where BillNo=@No and Status>0
GO