SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GePrintLabelLayoutView]

as

select * from dbo.PrintLabelLayout
GO