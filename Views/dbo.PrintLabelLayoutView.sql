SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PrintLabelLayoutView]
AS
SELECT     TOP 100 PERCENT PrintLabelLayoutID, LayoutName, LayoutContent, PrinterType
FROM         dbo.PrintLabelLayout
ORDER BY LayoutName
GO