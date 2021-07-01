CREATE TABLE [dbo].[Activity] (
  [ActivityID] [uniqueidentifier] NOT NULL,
  [ActivityNo] [int] NULL,
  [TableName] [int] NULL,
  [UserID] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL CONSTRAINT [DF_Activity_DateCreated] DEFAULT (getdate()),
  [Status] [smallint] NULL,
  [Description] [nvarchar](255) NULL,
  [RowID] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ActivityID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO