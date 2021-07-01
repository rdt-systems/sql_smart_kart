SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


	CREATE VIEW [dbo].[random_val_view]
AS
SELECT RAND() as  random_value
GO