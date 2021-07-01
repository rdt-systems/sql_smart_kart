SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SaveReportEmail]
(@Dll VARCHAR(500),@Schedule VARCHAR(50),@Time VARCHAR(50),@Day VARCHAR(50),@month VARCHAR(50),@ReportName VARCHAR(250),@UserId UNIQUEIDENTIFIER)
AS 



INSERT INTO dbo.TaskSchedules
(
    TaskName,
    Schedule,
    PathToExe,
    arguments,
    EmailOnFail,
    LastRunDate,
    LastRunStatus,
    Enabled,
    ExitCode,
    ProcessName,
    ProcessID
)
VALUES
(   '',       -- TaskName - nvarchar(50)
    'D201208291718ZZZZZZZZ000000001',       -- Schedule - nvarchar(50)
    @Dll,       -- PathToExe - nvarchar(250)
    'Rep-',       -- arguments - nvarchar(50)
    NULL,      -- EmailOnFail - bit
    GETDATE(), -- LastRunDate - datetime
    1,         -- LastRunStatus - int
    1,      -- Enabled - bit
    '0',       -- ExitCode - nvarchar(20)
    'SendReports',       -- ProcessName - nvarchar(50)
    0          -- ProcessID - int
)

DECLARE @TaskId AS INT
SELECT @TaskId=SCOPE_IDENTITY()

INSERT INTO dbo.ScheduleReports
(
    ReportName,
    Subject,
    Emails,
    ReportFilter,
    ReportLayout,
    DateCreated,
    DateModified,
    Status,
    ReportFile,
    TaskID,
    IsReport,
    StoreID,
    DailyInterval,
    IntervalType,
    MonthlyInterval,
    NextExecute,
    StartTime,
    WeeklyInterval
)
VALUES
(   @ReportName,       -- ReportName - nvarchar(50)
    @ReportName,       -- Subject - nvarchar(50)
    @UserId,        -- Emails - varchar(max)
    '',       -- ReportFilter - ntext
    '',       -- ReportLayout - ntext
    GETDATE(), -- DateCreated - datetime
    GETDATE(), -- DateModified - datetime
    1,         -- Status - int
    'EmailReport',       -- ReportFile - nvarchar(20)
    @TaskId,         -- TaskID - int
    NULL,      -- IsReport - bit
    NULL,      -- StoreID - uniqueidentifier
    NULL,       -- DailyInterval - nvarchar(50)
    NULL,       -- IntervalType - nvarchar(10)
    NULL,         -- MonthlyInterval - int
    NULL, -- NextExecute - datetime
    NULL, -- StartTime - datetime
    NULL        -- WeeklyInterval - nvarchar(10)
)
GO