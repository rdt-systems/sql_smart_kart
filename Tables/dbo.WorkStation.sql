CREATE TABLE [dbo].[WorkStation] (
  [ClientStationID] [nvarchar](50) NOT NULL,
  [ClientStationName] [nvarchar](50) NULL,
  [ClientStationStatus] [tinyint] NULL,
  [ChangedDataFlag] [bit] NULL,
  [UserNo] [uniqueidentifier] NULL
)
GO