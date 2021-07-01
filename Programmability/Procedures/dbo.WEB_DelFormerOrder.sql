SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_DelFormerOrder] 
(@WorkID uniqueidentifier)
AS
update workorder 
set status=-1
where workorderid=@WorkID
GO