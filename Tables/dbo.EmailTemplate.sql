CREATE TABLE [dbo].[EmailTemplate] (
  [EmailTemplateID] [uniqueidentifier] NOT NULL,
  [EmailFrom] [nvarchar](50) NULL,
  [Subject] [nvarchar](400) NULL,
  [Body] [ntext] NULL,
  [EmailContent] [image] NULL,
  [Category] [int] NULL,
  [FileName] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  CONSTRAINT [PK_EmailTemplate] PRIMARY KEY CLUSTERED ([EmailTemplateID])
)
GO