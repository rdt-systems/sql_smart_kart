CREATE TABLE [dbo].[SavedReports] (
  [ID] [int] IDENTITY,
  [ReportName] [nvarchar](50) NULL,
  [BaseReport] [nvarchar](50) NULL,
  [ReportFilter] [ntext] NULL,
  [ReportLayout] [ntext] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [int] NULL
)
GO