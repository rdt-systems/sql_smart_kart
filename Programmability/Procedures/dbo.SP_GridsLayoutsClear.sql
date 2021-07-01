SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GridsLayoutsClear]
as
delete from dbo.GridsLayouts
GO