CREATE TABLE [dbo].[ScheduleReports] (
  [ID] [int] IDENTITY,
  [ReportName] [nvarchar](50) NULL,
  [Subject] [nvarchar](50) NULL,
  [Emails] [varchar](max) NULL,
  [ReportFilter] [ntext] NULL,
  [ReportLayout] [ntext] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [int] NULL,
  [ReportFile] [nvarchar](20) NULL,
  [TaskID] [int] NOT NULL,
  [IsReport] [bit] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [DailyInterval] [nvarchar](50) NULL,
  [IntervalType] [nvarchar](10) NULL,
  [MonthlyInterval] [int] NULL,
  [NextExecute] [datetime] NULL,
  [StartTime] [datetime] NULL,
  [WeeklyInterval] [nvarchar](10) NULL,
  CONSTRAINT [PK_ScheduleReports] PRIMARY KEY CLUSTERED ([ID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		Eziel
-- ALTER date: 8/29/2012
-- Description:	Update Date Modified / Date Created
-- =============================================
CREATE TRIGGER [Tr_ScheduleReportsDate] 
   ON  [dbo].[ScheduleReports] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--Is Update
IF EXISTS (SELECT * FROM DELETED) 
    Begin
Update ScheduleReports Set DateModified = dbo.GetLocalDATE() where id = (select id from inserted)
    END
  
   ELSE
Update ScheduleReports Set DateCreated = dbo.GetLocalDATE() where id = (select id from inserted)  
  END
GO

ALTER TABLE [dbo].[ScheduleReports]
  ADD CONSTRAINT [FK_ScheduleReports_TaskSchedules] FOREIGN KEY ([TaskID]) REFERENCES [dbo].[TaskSchedules] ([ID])
GO