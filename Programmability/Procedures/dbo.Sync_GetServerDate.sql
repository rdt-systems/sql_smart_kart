﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_GetServerDate]


as


SELECT dbo.GetLocalDATE()
GO