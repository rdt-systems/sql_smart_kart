SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




-- =============================================
-- Author:		<Nathan Ehrenthal>
-- Create date: <10/19/1215>
-- Description:	<Send Transactiob abd send back a slot on the Conniver>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAvailableConniverSlot]
		@Slots Int,
		@StoreID As uniqueidentifier
AS
BEGIN
    DECLARE @AVL As int
    SET @AVL = 0
    DECLARE @tempRackNo Int
	DECLARE @RackNo Int

    DECLARE @Rack nvarchar(100)
	DECLARE @tempRack nvarchar(100)

    DECLARE cApply CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT DISTINCT RackNo,Rack
	FROM            Conveyor
	WHERE        (Reserved = 0) AND (StoreID = @StoreID)
	ORDER BY RackNo

	OPEN cApply

	FETCH NEXT FROM cApply 
	INTO @RackNo,@Rack

	WHILE @@FETCH_STATUS = 0 
    BEGIN
		IF @AVL=0 
		BEGIN
			select  min(RowNo)As vStart, max(RowNo)As vEnd into #CN
			from (select ta.*,
							(row_number() over (order by RowNo) -
							row_number() over (partition by Reserved order by RowNo)
							) as grp
					from Conveyor ta
					) ta
			where (Reserved = 0) AND (RackNo=@RackNo) AND (StoreID =@StoreID) And ([Status]=1)
			group by grp 

			SET @AVL =(SELECT IsNull(Min(vStart),0)  FROM #CN WHERE (vEnd+1-vStart)>=@Slots)
			SET @tempRackNo =@RackNo
            SET @tempRack =@Rack
			DROP Table #CN 
	    END

		FETCH NEXT FROM cApply 
		INTO @RackNo,@Rack
	END

	CLOSE cApply
	DEALLOCATE cApply
	UPDATE Conveyor Set Reserved =1 WHERE (RowNo >=@AVL AND RowNo <@AVL+@Slots) and (RackNo =@tempRackNo) and (StoreID =@StoreID) 
	SELECT  @tempRackNo As RackNo, @tempRack As Rack,@AVL As FirstAvailable    
END
GO