CREATE TABLE [dbo].[DistributeRequest] (
  [DistributeRequestID] [uniqueidentifier] NOT NULL,
  [DistributeRequestNo] [varchar](50) NULL,
  [DistributeRequestDate] [datetime] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_DistributeRequest_Status] DEFAULT (5),
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([DistributeRequestID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO