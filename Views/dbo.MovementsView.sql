SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[MovementsView]
AS
SELECT     ActionType, MovementType, Details, DebitAccount, CreditAccount, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.Movements
GO