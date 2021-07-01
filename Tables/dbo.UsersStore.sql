CREATE TABLE [dbo].[UsersStore] (
  [UserStoreID] [uniqueidentifier] NOT NULL,
  [UserID] [uniqueidentifier] NULL,
  [OnLine] [bit] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [IsDefault] [bit] NULL,
  [GroupID] [uniqueidentifier] NULL,
  [Manager] [bit] NULL,
  [LogonDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_UsersStore] PRIMARY KEY CLUSTERED ([UserStoreID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE UNIQUE INDEX [UserID_ItemStore]
  ON [dbo].[UsersStore] ([UserID])
  WHERE ([Status]>(-1) AND [UserID] IS NOT NULL)
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

ALTER TABLE [dbo].[UsersStore]
  ADD CONSTRAINT [FK_UsersStore_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserId])
GO