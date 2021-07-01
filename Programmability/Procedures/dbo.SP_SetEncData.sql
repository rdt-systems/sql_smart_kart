SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_SetEncData]
(@Data ntext)
as 
delete from encdata
insert into encdata (EncData) values(@Data)
GO