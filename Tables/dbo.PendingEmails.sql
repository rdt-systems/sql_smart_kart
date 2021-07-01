CREATE TABLE [dbo].[PendingEmails] (
  [PendingEmailID] [int] IDENTITY,
  [Subject] [nvarchar](128) NULL,
  [ToEmail] [nvarchar](128) NULL,
  [FromEmail] [nvarchar](128) NULL,
  [FromName] [nvarchar](128) NULL,
  [BccEmailList] [ntext] NULL,
  [IsHtml] [bit] NULL,
  [PendingEmailStatusID] [int] NULL,
  [Body] [nvarchar](2500) NULL,
  [ErrorMessage] [ntext] NULL,
  [CreationDate] [datetime] NULL,
  [DateModified] [datetime] NULL
)
GO