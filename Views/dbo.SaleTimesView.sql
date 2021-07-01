SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SaleTimesView]
AS
SELECT     SaleTimeID, SaleID, Sunday, SunFrom, SunTo, Munday, MunFrom, MunTo, Tuesday, TueFrom, TueTo, Wednesday, WedFrom, WedTo, Thursday, 
                      ThuFrom, ThuTo, Friday, FriFrom, FriTo, Saterday, SatFrom, SatTo, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.SaleTimes
WHERE     (Status > 0)
GO