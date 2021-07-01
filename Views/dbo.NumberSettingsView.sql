SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[NumberSettingsView]
AS
SELECT     StoreSymbol, TableName, SeqNumber, StartNum, [Desc], StoreID, TableNameHe
FROM         dbo.NumberSettings
GO