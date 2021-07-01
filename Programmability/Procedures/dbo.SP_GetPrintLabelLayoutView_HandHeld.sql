SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPrintLabelLayoutView_HandHeld]

as

select * from dbo.PrintLabelLayout
GO