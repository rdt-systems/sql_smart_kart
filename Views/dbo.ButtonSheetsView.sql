﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[ButtonSheetsView]
AS
SELECT * FROM [dbo].[ButtonSheets] WHERE Status > 0
GO