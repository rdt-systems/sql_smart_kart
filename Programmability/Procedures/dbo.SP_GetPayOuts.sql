SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetPayOuts]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT        PayOutView.*, CONVERT(nvarchar(500),STUFF((
				Select '',''+ cast(T.TenderName as varchar(30)) 
			 from TenderEntry TE inner join dbo.Tender T on T.TenderID = TE.TenderID where TE.TransactionID = PayOutView.PayOutID and TE.Status>0 
							FOR xml PATH ('''')), 1, 1, '''')) AS TenderName
			FROM PayOutView 
			WHERE        (PayOutView.Status > 0)   '
print (@MySelect + @Filter )

Execute (@MySelect + @Filter )
GO