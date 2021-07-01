CREATE TABLE [dbo].[Conveyor] (
  [ConveyorID] [int] IDENTITY,
  [Rack] [nvarchar](50) NOT NULL,
  [RowNo] [int] NOT NULL,
  [Reserved] [smallint] NULL,
  [RackNo] [int] NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_Conveyor_Status] DEFAULT (5),
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_Conveyor] PRIMARY KEY CLUSTERED ([ConveyorID]),
  CONSTRAINT [IX_Conveyor1] UNIQUE ([Rack], [RowNo], [StoreID])
)
GO