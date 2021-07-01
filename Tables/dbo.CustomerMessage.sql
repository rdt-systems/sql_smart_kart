CREATE TABLE [dbo].[CustomerMessage] (
  [CustomerMessageID] [uniqueidentifier] NOT NULL,
  [Message] [nvarchar](50) NULL,
  [IsDefault] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([CustomerMessageID])
)
GO