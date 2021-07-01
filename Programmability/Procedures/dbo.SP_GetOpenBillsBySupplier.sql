SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOpenBillsBySupplier]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.BillWithStoreID.*
                FROM       dbo.BillWithStoreID
				WHERE     (Status > 0 and ReceiveStatus>0)'
Execute (@MySelect + @Filter)
GO