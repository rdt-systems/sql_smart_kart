CREATE TABLE [dbo].[SaleToClub] (
  [ClubID] [uniqueidentifier] NOT NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [SaleID] [uniqueidentifier] NULL,
  [SaleToClubID] [uniqueidentifier] NOT NULL,
  [Status] [smallint] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ClubID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO