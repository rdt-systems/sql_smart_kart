SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt_AttendanceDetails]
(

@Filter nvarchar(4000)
)
as
declare @MySelect nvarchar(2000)


 --exec [Rpt_AttendanceDetails] @Filter=N'' 

begin

set @MySelect='SELECT ISNULL(dbo.Users.UserLName, '''') + '', '' + ISNULL(dbo.Users.UserFName, '''') AS EmployeeName,  convert(decimal(10,2), datediff(minute, PunchIn.InTime, PunchOut.OutTime) / 60.0) 
                         AS Time, DATENAME(dw, PunchIn.InTime) AS Weekday, PunchIn.InOutID, PunchIn.InTime, PunchOut.OutTime, PunchIn.StoreID, dbo.Users.UserName, 
                         dbo.Store.StoreName, PunchIn.UserID, PunchIn.OverTime, PunchIn.Sick, PunchIn.Holiday, PunchIn.Ragulare
FROM            dbo.Users INNER JOIN
                             (SELECT        Ragulare, Holiday, Sick, OverTime, PunchID, UserID, PunchTime AS InTime, PunchType, Status, RegisterID, InOutID, StoreID
                               FROM            dbo.Punches AS Punches_1
                               WHERE        (Status > 0) AND (PunchType = 1) AND (InOutID IS NOT NULL)) AS PunchIn ON dbo.Users.UserId = PunchIn.UserID LEFT OUTER JOIN
                         dbo.Store ON PunchIn.StoreID = dbo.Store.StoreID LEFT OUTER JOIN
                             (SELECT        PunchID, UserID, PunchTime AS OutTime, PunchType, Status, RegisterID, InOutID
                               FROM            dbo.Punches
                               WHERE        (Status > 0) AND (PunchType = 0) AND (InOutID IS NOT NULL)) AS PunchOut ON PunchIn.InOutID = PunchOut.InOutID Where 1=1
'

end

print (@MySelect +@Filter)

exec(@MySelect +@Filter)
GO