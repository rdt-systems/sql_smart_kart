SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SP_SaveRepUsage]
(@RepNama nvarchar(50),
@UserId uniqueidentifier,
@DateUsed datetime )
as 


insert into ReportsUsed (RepNama,UserId,DateUsed)
values (@RepNama,@UserId,@DateUsed)
GO