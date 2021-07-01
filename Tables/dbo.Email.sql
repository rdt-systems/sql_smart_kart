CREATE TABLE [dbo].[Email] (
  [EmailID] [uniqueidentifier] NOT NULL,
  [EmailAddress] [nvarchar](50) NULL,
  [OnlyText] [bit] NULL,
  [EmailSizeLimit] [tinyint] NULL,
  [DefaultEmail] [bit] NULL,
  [SortOrder] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([EmailID])
)
GO