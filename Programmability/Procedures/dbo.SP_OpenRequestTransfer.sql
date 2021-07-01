SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OpenRequestTransfer]
@Filter  nvarchar(4000)


AS
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT        RequestTransferID, RequestNo, Status, RequestTransferView.Status,fromStoreid, toStoreid
FROM           RequestTransferView
 WHERE        (RequestStatus < 2) AND (Status > 0) AND (openItems > 0)  '
Execute (@MySelect + @Filter )
GO