CREATE TABLE [dbo].[ReportsTable] (
  [ReportName] [varchar](250) NULL,
  [ReportDescription] [varchar](4000) NULL,
  [ReportSection] [varchar](250) NULL,
  [ReportDll] [varchar](250) NULL,
  [Status] [bit] NULL,
  [SortOrder] [int] NULL,
  [ReportType] [varchar](250) NULL,
  [Handlers] [varchar](250) NULL,
  [Icon] [varchar](100) NULL
)
GO