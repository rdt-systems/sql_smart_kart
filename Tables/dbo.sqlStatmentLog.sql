CREATE TABLE [dbo].[sqlStatmentLog] (
  [id] [int] IDENTITY,
  [sqlString] [varchar](5000) NULL,
  [DateInsert] [datetime] NOT NULL CONSTRAINT [DF_sqlStatmentLog_DateInsert] DEFAULT (getdate())
)
GO