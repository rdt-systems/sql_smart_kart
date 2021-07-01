CREATE TABLE [dbo].[ShipVia] (
  [ShipViaID] [uniqueidentifier] NOT NULL,
  [ShipViaName] [nvarchar](50) NULL,
  [ShipViaCost] [money] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ShipViaID])
)
GO