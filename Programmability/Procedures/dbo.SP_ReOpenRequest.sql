SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_ReOpenRequest](@ID Uniqueidentifier)

AS
Declare @Status Int
BEGIN

SELECT @Status = CASE WHEN SUM(ISNULL(TransferQty,0)) <> 0 AND SUM(ISNULL(TransferQty,0)) < SUM(ISNULL(Qty,0)) THEN 1 ELSE  0 END 
FROM            RequestTransferEntryView
WHERE        (RequestTransferID = @ID)

UPDATE  TransferItems set TransferStatus = @Status, DateModified = dbo.GetLocalDATE() Where TransferID = @ID

Exec OnRequestUpdate

END
GO