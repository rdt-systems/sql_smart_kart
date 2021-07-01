SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TimeAttendanceView]
AS
SELECT        TOP (100) PERCENT DATENAME(dw, PunchIn.InTime) AS Weekday, PunchIn.InOutID, PunchIn.InTime, PunchOut.OutTime, PunchIn.StoreID, dbo.Users.UserName, 
                         dbo.Store.StoreName, PunchIn.UserID, PunchIn.Ragulare, PunchIn.Holiday, PunchIn.OverTime, PunchIn.Sick, PunchIn.PunchID, PunchIn.PunchType, PunchIn.Status, 
                         ISNULL(dbo.Users.UserLName, N'') + N' ' + ISNULL(dbo.Users.UserFName, N'') AS FullName, dbo.Store.StoreNumber
FROM            dbo.Users INNER JOIN
                             (SELECT        PunchID, UserID, PunchTime AS InTime, PunchType, Status, RegisterID, InOutID, StoreID, Ragulare, Holiday, OverTime, Sick
                               FROM            dbo.Punches AS Punches_1
                               WHERE        (Status > 0) AND (PunchType = 1) AND (InOutID IS NOT NULL)) AS PunchIn ON dbo.Users.UserId = PunchIn.UserID LEFT OUTER JOIN
                         dbo.Store ON PunchIn.StoreID = dbo.Store.StoreID LEFT OUTER JOIN
                             (SELECT        PunchID, UserID, PunchTime AS OutTime, PunchType, Status, RegisterID, InOutID
                               FROM            dbo.Punches
                               WHERE        (Status > 0) AND (PunchType = 0) AND (InOutID IS NOT NULL)) AS PunchOut ON PunchIn.InOutID = PunchOut.InOutID
GO