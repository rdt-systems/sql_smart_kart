CREATE TABLE [dbo].[TransType] (
  [TransType] [int] NOT NULL,
  [TransName] [varchar](50) NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL
)
GO