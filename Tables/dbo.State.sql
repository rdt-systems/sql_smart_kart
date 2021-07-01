CREATE TABLE [dbo].[State] (
  [StateCode] [nvarchar](50) NOT NULL,
  [StateName] [nvarchar](50) NULL,
  [StateSort] [int] NULL,
  CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED ([StateCode]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO