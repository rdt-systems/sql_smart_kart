SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetPayOutEntries]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT   TransactionID,tenderName,-Amount as Amount
		FROM TenderEntry Inner Join Tender On Tender.TenderID = TenderEntry.TenderID
		WHERE  TenderEntry.Status>-1  and exists (select 1  from PayOut where status>0 and PayOutID=TenderEntry.TransactionID '
Execute (@MySelect + @Filter + ')')
GO