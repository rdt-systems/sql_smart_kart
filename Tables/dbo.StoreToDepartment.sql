CREATE TABLE [dbo].[StoreToDepartment] (
  [StoreToDepartmentID] [uniqueidentifier] NOT NULL,
  [StoreID] [uniqueidentifier] NULL,
  [DepartmentID] [uniqueidentifier] NULL,
  [DefaultMarkup] [decimal](19, 3) NULL,
  [RoundUp] [uniqueidentifier] NULL,
  [RoundValue] [decimal](18, 3) NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_StoreToDepartment] PRIMARY KEY CLUSTERED ([StoreToDepartmentID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO