SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SerialView]
AS
SELECT     dbo.Serialization.*
FROM         dbo.Serialization
WHERE     (Status > - 1)
GO