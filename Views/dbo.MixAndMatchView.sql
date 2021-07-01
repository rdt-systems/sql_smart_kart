SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[MixAndMatchView]
WITH SCHEMABINDING 
AS
SELECT        MixAndMatchID, Name, Qty, Amount, AssignDate, StartDate, EndDate, MinTotalSale, Status, DateCreated, UserCreated, DateModified, UserModified
FROM            dbo.MixAndMatch
GO