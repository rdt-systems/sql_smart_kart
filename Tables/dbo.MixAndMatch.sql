CREATE TABLE [dbo].[MixAndMatch] (
  [MixAndMatchID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [Qty] [int] NULL,
  [Amount] [money] NULL,
  [AssignDate] [bit] NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [MinTotalSale] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_MixAndMatch] PRIMARY KEY CLUSTERED ([MixAndMatchID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO