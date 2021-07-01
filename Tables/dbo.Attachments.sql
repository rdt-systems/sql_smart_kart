CREATE TABLE [dbo].[Attachments] (
  [AttachmentID] [uniqueidentifier] NOT NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Description] [nvarchar](4000) NULL,
  [FileName] [nvarchar](50) NULL,
  [Attachment] [image] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([AttachmentID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO