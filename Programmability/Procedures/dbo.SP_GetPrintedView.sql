SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetPrintedView]

as

select * from dbo.Printed
where isnull(status,1) >-1
GO