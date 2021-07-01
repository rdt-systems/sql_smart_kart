CREATE TABLE [dbo].[Club] (
  [ClubID] [uniqueidentifier] NOT NULL,
  [ClubName] [nvarchar](50) NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [smallint] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ClubID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO