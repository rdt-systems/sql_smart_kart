CREATE TABLE [dbo].[DBUpdates] (
  [Version] [float] NOT NULL,
  [UpdateText] [varchar](8000) NULL,
  [Sort] [smallint] NULL,
  [Comment] [nvarchar](100) NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_DBUpdates_Status] DEFAULT (1),
  [DateCreated] [datetime] NULL CONSTRAINT [DF_DBUpdates_DateCreated] DEFAULT (getdate()),
  [UserCreated] [nvarchar](30) NULL
)
GO