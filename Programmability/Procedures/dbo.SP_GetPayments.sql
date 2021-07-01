SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPayments]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.SupplierTenderEntryView.*,
		                  (Select Case when TenderID=2 Then (cast(Common4 as DateTime)) else Null end) As [Check Date],
		                  (Select Count(*) from dbo.PayToBill as NumApplyBills where SuppTenderID=dbo.SupplierTenderEntryView.SuppTenderEntryID) as NumApplyBills
		        FROM       dbo.SupplierTenderEntryView
	            WHERE     '
Execute (@MySelect + @Filter )
GO