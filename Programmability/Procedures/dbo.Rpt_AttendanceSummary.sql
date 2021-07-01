SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_AttendanceSummary]
(

@Filter nvarchar(4000)

)
as
declare @MySelect nvarchar(2000)

 --exec Rpt_AttendanceSummary @Filter=N''

begin

set @MySelect='SELECT ISNULL(dbo.Users.UserLName, '''') + '', '' + ISNULL(dbo.Users.UserFName, '''') AS EmployeeName,
 convert(decimal(10,2), SUM(datediff(minute, PunchIn.InTime, PunchOut.OutTime)) / 60.0) As TotalHours                                          
FROM            dbo.Users INNER JOIN
                             (SELECT        PunchID, UserID, PunchTime AS InTime, PunchType, Status, RegisterID, InOutID, StoreID
                               FROM            dbo.Punches AS Punches_1
                               WHERE        (Status > 0) AND (PunchType = 1) AND (InOutID IS NOT NULL)) AS PunchIn ON dbo.Users.UserId = PunchIn.UserID LEFT OUTER JOIN
                         dbo.Store ON PunchIn.StoreID = dbo.Store.StoreID LEFT OUTER JOIN
                             (SELECT        PunchID, UserID, PunchTime AS OutTime, PunchType, Status, RegisterID, InOutID
                               FROM            dbo.Punches
                               WHERE        (Status > 0) AND (PunchType = 0) AND (InOutID IS NOT NULL)) AS PunchOut ON PunchIn.InOutID = PunchOut.InOutID
 Where 1=1 '
 

end

print (@MySelect +@Filter +  'Group By users.UserId, dbo.Users.UserLName ,dbo.Users.UserFName')

exec(@MySelect +@Filter +  'Group By users.UserId, dbo.Users.UserLName ,dbo.Users.UserFName Order BY dbo.Users.UserLName')



--SELECT ISNULL(dbo.Users.UserLName, '') + ', ' + ISNULL(dbo.Users.UserFName, '') AS EmployeeName, max(CAST(DATEDIFF(minute, PunchIn.InTime, PunchOut.OutTime) / 60 AS varchar(5)) + ':' + RIGHT('0' + CAST(DATEDIFF(minute, PunchIn.InTime, PunchOut.OutTime) % 60 AS varchar(2)), 2)) As TotalHours                       
--FROM            dbo.Users INNER JOIN
--                             (SELECT        PunchID, UserID, PunchTime AS InTime, PunchType, Status, RegisterID, InOutID, StoreID
--                               FROM            dbo.Punches AS Punches_1
--                               WHERE        (Status > 0) AND (PunchType = 1) AND (InOutID IS NOT NULL)) AS PunchIn ON dbo.Users.UserId = PunchIn.UserID 
--                        LEFT OUTER JOIN
--                             (SELECT        PunchID, UserID, PunchTime AS OutTime, PunchType, Status, RegisterID, InOutID
--                               FROM            dbo.Punches
--                               WHERE        (Status > 0) AND (PunchType = 0) AND (InOutID IS NOT NULL)) AS PunchOut ON PunchIn.InOutID = PunchOut.InOutID
-- Where 1=1 Group By users.UserId, dbo.Users.UserLName ,dbo.Users.UserFName
GO