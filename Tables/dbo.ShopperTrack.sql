CREATE TABLE [dbo].[ShopperTrack] (
  [ID] [int] IDENTITY,
  [enters] [int] NULL,
  [exits] [int] NULL,
  [stime] [datetime] NULL,
  [devid] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [int] NULL,
  [StoreNo] [nvarchar](20) NULL,
  [StoreID] [uniqueidentifier] NULL,
  CONSTRAINT [PK__ShopperT__3214EC27E58C4038] PRIMARY KEY CLUSTERED ([ID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO