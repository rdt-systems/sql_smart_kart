SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetDefaultPrintLabelLayoutView]

as

select * from dbo.DefaultPrintLabelLayout
ORDER BY LayoutName
GO