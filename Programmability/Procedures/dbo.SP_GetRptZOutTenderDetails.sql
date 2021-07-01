SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRptZOutTenderDetails]
(
@BatchID uniqueidentifier,
@TenderID int=-1
)
AS

if @TenderID=-1

SELECT     	dbo.BatchTenderDetailsView.*
FROM         	dbo.BatchTenderDetailsView
WHERE	BatchID=@BatchID 

else

SELECT     	dbo.BatchTenderDetailsView.*
FROM         	dbo.BatchTenderDetailsView
WHERE	BatchID=@BatchID And TenderID = @TenderID
GO