CREATE TABLE [dbo].[SeasonEntry] (
  [SeasonEntryId] [uniqueidentifier] NOT NULL,
  [SeasonNo] [uniqueidentifier] NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([SeasonEntryId]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO