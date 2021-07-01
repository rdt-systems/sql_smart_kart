CREATE TABLE [dbo].[Errors] (
  [ErrorID] [uniqueidentifier] NOT NULL,
  [Source] [nvarchar](50) NULL,
  [Machine] [nvarchar](50) NULL,
  [UserName] [nvarchar](50) NULL,
  [EventId] [bigint] NULL,
  [Message] [nvarchar](4000) NOT NULL,
  [DateCreated] [datetime] NOT NULL,
  PRIMARY KEY CLUSTERED ([ErrorID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO