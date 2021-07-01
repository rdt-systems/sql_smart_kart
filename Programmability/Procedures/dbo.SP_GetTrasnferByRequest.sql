SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetTrasnferByRequest]

(@RequestTransferEntryID uniqueidentifier)

AS 

					  select distinct t3.TransferID ,t3.TransferNo,t3.TransferDate
						  from TransferEntry t2 , TransferItems t3 
						  where t2.TransferID=t3.TransferID
						  and t2.RequestTransferEntryID =@RequestTransferEntryID
GO