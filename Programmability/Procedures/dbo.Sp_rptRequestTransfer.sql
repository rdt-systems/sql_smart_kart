SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_rptRequestTransfer]
(@Filter nvarchar(4000))
AS

DECLARE @MySelect nvarchar(4000)

SET @MySelect ='SELECT       * 
FROM            RequestTransferEntryView INNER JOIN
                         RequestTransferView ON RequestTransferEntryView.requesttransferid = RequestTransferView.requesttransferid'

print (@MySelect + @Filter )
Execute (@MySelect + @Filter )
GO