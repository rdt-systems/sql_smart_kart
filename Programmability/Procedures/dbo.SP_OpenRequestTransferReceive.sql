SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_OpenRequestTransferReceive]
@Filter  nvarchar(4000)


AS
declare @MySelect nvarchar(4000)
set @MySelect= 'select ReceiveTransferID,ReceiveNo, Status, TransferStatus, TransferNo, TransferUser, ReceiveUser, StoreReceived, FromStore, ToStore, transferid 
from ReceiveTransferView 
 WHERE        (TransferStatus <= 2) AND (Status > 0)  '
Execute (@MySelect + @Filter )
GO