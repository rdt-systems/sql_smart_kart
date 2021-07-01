CREATE TABLE [dbo].[Reports] (
  [id_report] [int] IDENTITY,
  [ReportName] [nvarchar](250) NULL,
  [Data] [varbinary](max) NULL,
  CONSTRAINT [PK_Reports] PRIMARY KEY CLUSTERED ([id_report])
)
GO