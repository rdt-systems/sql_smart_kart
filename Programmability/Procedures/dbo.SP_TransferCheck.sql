SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_TransferCheck]
(@TenderEntryID uniqueidentifier)
as
insert into BookkeepingChecks values(@TenderEntryID)
GO