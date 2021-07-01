SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTenderAndTenderEntry]
(
@TransactionID uniqueidentifier,
@TenderType int=-1
)
AS

if @TenderType=-1

SELECT     dbo.TenderView.TenderName, dbo.TenderEntryView.Amount, dbo.TenderEntryView.Common1 Com1, dbo.TenderEntryView.Common2 Com2, 
                      dbo.TenderEntryView.Common3 Com3, dbo.TenderEntryView.Common4 Com4, dbo.TenderEntryView.Common5, dbo.TenderEntryView.TenderDate, 
                      dbo.TenderEntryView.TransactionID, dbo.TenderEntryView.TenderID, dbo.TenderEntryView.TenderEntryID, dbo.TenderEntryView.Common6, 
                      dbo.TenderEntryView.Status, dbo.TenderEntryView.DateCreated, dbo.TenderEntryView.UserCreated, dbo.TenderEntryView.DateModified, 
                      dbo.TenderEntryView.UserModified, dbo.TenderView.TenderType, dbo.TenderView.TenderDescription
FROM         dbo.TenderView LEFT OUTER JOIN
                      dbo.TenderEntryView ON dbo.TenderView.TenderID = dbo.TenderEntryView.TenderID 
		      AND dbo.TenderEntryView.TransactionID = @TransactionID  
where   TenderType=2--Actual Cash
and TenderEntryView.status >0
else

SELECT      sum(dbo.TenderEntryView.Amount)Amount
FROM         dbo.TenderView LEFT OUTER JOIN
                      dbo.TenderEntryView ON dbo.TenderView.TenderID = dbo.TenderEntryView.TenderID 
		      AND dbo.TenderEntryView.TransactionID = @TransactionID  
where   TenderType=@TenderType
and TenderEntryView.status >0
GO