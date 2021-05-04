IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Checkscan_getAllChecksProcessed')
	BEGIN
		DROP  Procedure  stp_Checkscan_getAllChecksProcessed
	END

GO

CREATE Procedure stp_Checkscan_getAllChecksProcessed
	(
		@from datetime = null,
		@to datetime = null
	)
AS
BEGIN

	SET ARITHABORT ON
	SET ANSI_NULLS ON


	if @from is null BEGIN
		set @from = convert(varchar,getdate(),101) + ' 12:00 AM'
	end
	if @to is null BEGIN
		set @to = convert(varchar,getdate(),101) + ' 11:59 PM'
	end

	declare @from1 datetime, @to1 datetime

	set @from1 = @from
	SET @to1 = @to

	declare @tblShow table(ProcessingRegisterId int, RegisterID int, Check21ID int, ClientID int, ClientName varchar(50), CheckType varchar(50)
	, CheckRouting varchar(50), CheckAccountNum varchar(50), CheckNumber varchar(50), CheckAmount float, Verified datetime
	, VerifiedBy int, VerifiedByName varchar(50), Processed varchar(50), ProcessedBy int, ProcessedByName varchar(50)
	, ICLFileName varchar(500), CheckFrontPath varchar(500), CheckBackPath varchar(500), MissingProcessingRegisterID  bit
	, BundleID int, ProcessStatus varchar(500), saveguid varchar(50) , rowNum int, rowprocessed bit)

	declare @tblData table(ProcessingRegisterId int, RegisterID int, Check21ID int, ClientID int, ClientName varchar(50), CheckType varchar(50)
	, CheckRouting varchar(50), CheckAccountNum varchar(50), CheckNumber varchar(50), CheckAmount float, Verified datetime
	, VerifiedBy int, VerifiedByName varchar(50), Processed varchar(50), ProcessedBy int, ProcessedByName varchar(50)
	, ICLFileName varchar(500), CheckFrontPath varchar(500), CheckBackPath varchar(500), MissingProcessingRegisterID  bit
	, BundleID int, ProcessStatus varchar(500), saveguid varchar(50) , rowNum int, rowprocessed bit)
	declare @tblFiles table(fhid int, processed bit)
	declare @tblCashLtrs table(chid varchar(8), CashLetterHeaderId int, processed bit)
	declare @tblCashLtrHdr table(CashLetterHeaderId int, processed bit)
	declare @tblAdjItemID table(ItemAdjustmentDetailId int)
	declare @tblICLFiles table(iclname varchar(1000))
	DECLARE @tblBadTemp table(ItemDetailAddendumId int,CashLetterID varchar(8),ItemAdjustmentDetailID int,AddendumRecordNumber int,AdjustmentReasonNumber int,AdjustmentReasonDetail varchar(1000))
	DECLARE @tblBad table(CashLetterID varchar(8),ItemAdjustmentDetailID int,AddendumRecordNumber int,AdjustmentReasonNumber int,AdjustmentReasonDetail varchar(1000))
	declare @FileHeaderID int, @CashLetterHeaderId int, @cashletterid varchar(8)

	insert into @tblFiles
	select FileHeaderId,0 FROM [WA]..tblICLACKFileHeader_01 afh where created BETWEEN @from1 AND @to1
	WHILE EXISTS ( SELECT * FROM @tblFiles WHERE PROCESSED = 0) 
		BEGIN
			--GET CURRENT ROW
			SELECT @FileHeaderID = MIN(fhid) FROM @tblFiles WHERE PROCESSED = 0 
						
			INSERT INTO @tblCashLtrs
			select cashletterid,CashLetterHeaderId,0 FROM [WA]..tblICLACKCashLetterHeader_10 where FileHeaderID = @FileHeaderID

			WHILE EXISTS ( SELECT * FROM @tblCashLtrs WHERE PROCESSED = 0) 
				BEGIN
					--GET CURRENT ROW
					SELECT @CashLetterHeaderId = MIN(CashLetterHeaderId) FROM @tblCashLtrs WHERE PROCESSED = 0 
					select @cashletterid = chid from @tblCashLtrs where CashLetterHeaderId = @CashLetterHeaderId
							
					insert into @tblAdjItemID
					select ItemAdjustmentDetailId FROM [WA]..tblICLACKItemAdjustmentDetail_25 where CashLetterHeaderID =@CashLetterHeaderId
				
					--select * FROM [WA]..tblICLACKItemDetailAddendum_26 where  ItemAdjustmentDetailID in (select ItemAdjustmentDetailId from @tblAdjItemID)
					--select * from @tblBad
				
					INSERT into @tblBadTemp
					select aida.ItemDetailAddendumId, @cashletterid, aiad.ItemAdjustmentDetailId
					,aiad.ItemSequenceNumber,aida.AdjustmentReasonNumber
					,aida.AdjustmentReasonDetail 
					FROM [WA]..tblICLACKItemAdjustmentDetail_25  aiad
					left JOIN [WA]..tblICLACKItemDetailAddendum_26 aida on aiad.ItemAdjustmentDetailID = aida.ItemAdjustmentDetailID
					where aiad.CashLetterHeaderID =@CashLetterHeaderId
				
				
					insert into @tblBad
					SELECT @cashletterid, ItemAdjustmentDetailId,AddendumRecordNumber,AdjustmentReasonNumber,				
					replace(Stuff( (SELECT N', ' + AdjustmentReasonDetail FROM @tblBadTemp FOR XML PATH(''),TYPE) .value('text()[1]','nvarchar(max)'),1,2,N'') ,'  ','')
					FROM @tblBadTemp 
						
					insert into @tblICLFiles
					SELECT replace(reverse(left(reverse(FileName), charindex('\',reverse(FileName), 1) - 1)),'.x937','') 
					FROM tblICLFileHeader where ICLFileId in (select ICLFileId FROM tblICL_CashLetterHeader where CashLetterId =@cashletterid)

					insert into @tblData
					SELECT distinct r.RegisterId[ProcessingRegisterId], ic.RegisterID, ic.Check21ID, c.ClientID, p.FirstName + ' ' + p.LastName[ClientName]
					, ic.CheckType, ic.CheckRouting, ic.CheckAccountNum, ic.CheckNumber, ic.CheckAmount, ic.Verified, ic.VerifiedBy, vu.FirstName + ' ' + vu.LastName[VerifiedByName]
					, ic.Processed, ic.ProcessedBy, pu.FirstName + ' ' + pu.LastName[ProcessedByName], ic.ICLFileName, ic.CheckFrontPath, ic.CheckBackPath
					, CASE WHEN r.RegisterId IS NULL then 1 ELSE 0 end[MissingProcessingRegisterID]
					, max(cd.BundleID),NULL,MAX(saveguid)
					,ROW_NUMBER() over(partition by SaveGuid ORDER by Check21id ) ,0
					from tblICLChecks ic 
					left JOIN tblClient c ON c.ClientID = ic.ClientID
					INNER JOIN tblPerson p ON p.PersonID = c.PrimaryPersonID
					left JOIN tblRegister r on r.RegisterId = ic.RegisterID
					INNER join tblUser vu ON vu.UserID = ic.VerifiedBy
					INNER join tblUser pu ON pu.UserID = ic.ProcessedBy
					inner JOIN tblICL_CheckDetail cd on ltrim(rtrim(ic.CheckOnUs)) = ltrim(rtrim(cd.OnUs))
					where ic.RegisterID <> -1 and ic.DeleteDate IS null and ICLFileName in (SELECT iclname from @tblICLFiles)
					and r.Void is NULL AND r.Bounce IS null
					group by ic.SaveGUID ,r.RegisterId, ic.RegisterID, ic.Check21ID, c.ClientID, p.FirstName + ' ' + p.LastName
					, ic.CheckType, ic.CheckRouting, ic.CheckAccountNum, ic.CheckNumber, ic.CheckAmount, ic.Verified, ic.VerifiedBy, vu.FirstName + ' ' + vu.LastName, ic.Processed, ic.ProcessedBy, pu.FirstName + ' ' + pu.LastName, ic.ICLFileName, ic.CheckFrontPath
					, ic.CheckBackPath

					--SELECT * from @tblBad
					UPDATE @tblData
					SET ProcessStatus = isnull(AdjustmentReasonDetail ,'Accepted')
					from @tblData
					left JOIN @tblBad on [@tblData].rowNum = [@tblBad].AddendumRecordNumber

					INSERT into @tblshow
					SELECT * from @tblData
				
					delete FROM @tblData
					delete FROM @tblICLFiles
					delete FROM @tblBad
					delete FROM @tblAdjItemID
				
					UPDATE @tblCashLtrs SET  PROCESSED = 1  WHERE CashLetterHeaderId = @CashLetterHeaderId 
				END
	
				delete from @tblCashLtrs
				
			UPDATE @tblFiles SET  PROCESSED = 1  WHERE fhid = @FileHeaderID 
		END

	select * 
	from @tblShow
	order BY Processed ,saveguid,Check21ID

	
	SET ARITHABORT OFF
	SET ANSI_NULLS OFF


END

GO


GRANT EXEC ON stp_Checkscan_getAllChecksProcessed TO PUBLIC

GO


