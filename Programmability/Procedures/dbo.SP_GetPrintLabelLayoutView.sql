SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPrintLabelLayoutView]

as

select * from dbo.PrintLabelLayout
where isnull(Status,1)>-1
ORDER BY LayoutName
GO