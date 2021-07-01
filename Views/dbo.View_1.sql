SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[View_1]
AS
SELECT     TOP 100 PERCENT Matrix1 AS Color, Matrix2 AS Size, Matrix3 AS Style, (CASE WHEN Status > 0 THEN 0 ELSE - 1 END) AS Field, Status, StoreNo
FROM         dbo.ItemMainAndStoreView
WHERE     (LinkNo = '3708e6ee-d3b1-4e98-8982-c4aa72528ce8') AND (StoreNo = '72A4E5BE-40A0-49E3-9CFE-747C2425A11B') AND (Status > 0)
GO