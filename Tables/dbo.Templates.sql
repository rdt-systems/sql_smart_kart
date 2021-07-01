CREATE TABLE [dbo].[Templates] (
  [ID] [int] IDENTITY,
  [Templete] [ntext] NULL,
  [Images] [image] NULL,
  [UserID] [uniqueidentifier] NULL
)
GO

ALTER TABLE [dbo].[Templates]
  ADD CONSTRAINT [FK_Templates_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserId])
GO