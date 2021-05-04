ALTER PROCEDURE [dbo].[stp_CollectACHCommission]

AS

set nocount on
set ansi_warnings off

declare @companyid int

declare @commrecid int
declare @recdisplay varchar(100)
declare @recispersonal bit
declare @recroutingnumber varchar(9)
declare @recaccountnumber varchar(25)
declare @recaccounttype varchar

declare @parcommrecid int
declare @pardisplay varchar(100)
declare @parispersonal bit
declare @parroutingnumber varchar(9)
declare @paraccountnumber varchar(25)
declare @paraccounttype varchar

declare @transferamount money
declare @nacharegisterid int
declare @trustid int

declare @vtblCommBatches table
(
	CompanyID int,
	TrustID int,
	CommBatchTransferID int,
	CommRecID int,
	RecDisplay varchar(100),
	RecIsPersonal bit,
	RecRoutingNumber varchar(9),
	RecAccountNumber varchar(25),
	RecAccountType varchar,
	ParentCommRecID int,
	ParDisplay varchar(100),
	ParIsPersonal bit,
	ParRoutingNumber varchar(9),
	ParAccountNumber varchar(25),
	ParAccountType varchar,
	TransferAmount money
)
	

BEGIN TRY

	INSERT INTO
		@vtblCommBatches
	SELECT
		cbt.CompanyID,
		cbt.TrustID,
		cbt.CommBatchTransferID,
		rec.CommRecID as CommRecID,
		rec.Display as RecDisplay,
		~rec.IsCommercial as RecIsPersonal,
		rec.RoutingNumber as RecRoutingNumber,
		rec.AccountNumber as RecAccountNumber,
		isnull(rec.[Type], 'C') as RecAccountType,
		par.CommRecID as ParentCommRecID,
		par.Display as ParDisplay,
		~par.IsCommercial as ParIsPersonal,
		par.RoutingNumber as ParRoutingNumber,
		par.AccountNumber as ParAccountNumber,
		isnull(par.[Type], 'C') as ParAccountType,
		round(cbt.TransferAmount, 2)
	FROM
		tblCommBatchTransfer as cbt
		inner join tblCommRec as rec on rec.CommRecID = cbt.CommRecID and rec.IsLocked = 0 and lower(rec.Method) = 'ach'
		left join tblCommRec as par on par.CommRecID = cbt.ParentCommRecID
	WHERE
		cbt.CheckDate is null
		and cbt.CheckNumber is null
		and cbt.CompanyID is not null
		and cbt.CommBatchTransferID not in
		(
			SELECT
				nc.TypeID
			FROM
				tblNachaCabinet as nc
				inner join tblNachaRegister as nr on nr.NachaRegisterID = nc.NachaRegisterID
			WHERE
				nr.IsDeclined = 0
				and lower(nc.Type) = 'commbatchtransferid'
				and nc.TrustID = 20 -- Colonial clients
				
			union all
			
			select
				nc.typeid
			from
				tblnachacabinet nc inner join
				tblnacharegister2 nr on nc.nacharegisterid = nr.nacharegisterid
			where
				lower(nc.Type) = 'commbatchtransferid'
				and nc.TrustID = 22 -- CheckSite clients				
		)


	declare cursor_CollectionACHCommission cursor forward_only read_only for
		SELECT
			CompanyID,
			TrustID,
			CommRecID,
			RecDisplay,
			RecIsPersonal,
			RecRoutingNumber,
			RecAccountNumber,
			RecAccountType,
			ParentCommRecID,
			ParDisplay,
			ParIsPersonal,
			ParRoutingNumber,
			ParAccountNumber,
			ParAccountType,
			sum(TransferAmount) as TransferAmount
		FROM
			@vtblCommBatches
		WHERE
			ParentCommRecID is not null
		GROUP BY
			CompanyID,
			TrustID,
			CommRecID,
			RecDisplay,
			RecIsPersonal,
			RecRoutingNumber,
			RecAccountNumber,
			RecAccountType,
			ParentCommRecID,
			ParDisplay,
			ParIsPersonal,
			ParRoutingNumber,
			ParAccountNumber,
			ParAccountType

	open cursor_CollectionACHCommission

	fetch next from cursor_CollectionACHCommission into @companyid, @trustid, @commrecid, @recdisplay, @recispersonal, @recroutingnumber, @recaccountnumber, @recaccounttype, @parcommrecid, @pardisplay, @parispersonal, @parroutingnumber, @paraccountnumber, @paraccounttype, @transferamount

	while @@fetch_status = 0
	begin
		
		if @trustid = 22 begin -- CheckSite
			if exists (select 1 from tblCommRec where CommRecID = @parcommrecid and IsGCA = 1) begin
				-- write out a credit to the recipient
				exec @nacharegisterid = stp_InsertShadowCommission @commrecid, @recdisplay, @recaccountnumber, @recroutingnumber, @recaccounttype, @transferamount, @recispersonal, @companyid, @trustid
				
				-- insert nacha cabinet records against all commbatchtransfers associated with this payment
				INSERT INTO
					tblNachaCabinet
					(
						NachaRegisterID,
						[Type],
						TypeID,
						TrustID
					)
				SELECT
					@nacharegisterid,
					'CommbatchTransferID',
					CommBatchTransferID,
					TrustID
				FROM
					@vtblCommBatches
				WHERE
					CompanyID = @companyid
					and CommRecID = @commrecid
					and ParentCommRecID = @parcommrecid
					and TrustID = @trustid
			end
		end
		else begin
			-- write out a debit against the parent recipient
			INSERT INTO
				tblNachaRegister
				(
					[Name],
					AccountNumber,
					RoutingNumber,
					[Type],
					Amount,
					IsPersonal,
					CommRecID,
					CompanyID
				)
			VALUES
				(
					@pardisplay,
					@paraccountnumber,
					@parroutingnumber,
					@paraccounttype,
					round(-@transferamount, 2),
					@parispersonal,
					@parcommrecid,
					@companyid
				)

			set @nacharegisterid = scope_identity()


			-- insert nacha cabinet records against all commbatchtransfers associated with this payment
			INSERT INTO
				tblNachaCabinet
				(
					NachaRegisterID,
					[Type],
					TypeID,
					TrustID
				)
			SELECT
				@nacharegisterid,
				'CommbatchTransferID',
				CommBatchTransferID,
				TrustID
			FROM
				@vtblCommBatches
			WHERE
				CompanyID = @companyid
				and CommRecID = @commrecid
				and ParentCommRecID = @parcommrecid
				and TrustID = @trustid
			
			
			-- write out a credit to the recipient
			INSERT INTO
				tblNachaRegister
				(
					[Name],
					AccountNumber,
					RoutingNumber,
					[Type],
					Amount,
					IsPersonal,
					CommRecID,
					CompanyID
				)
			VALUES
				(
					@recdisplay,
					@recaccountnumber,
					@recroutingnumber,
					@recaccounttype,
					round(@transferamount, 2),
					@recispersonal,
					@parcommrecid,
					@companyid
				)

			set @nacharegisterid = scope_identity()
		
			
			-- insert nacha cabinet records against all commbatchtransfers associated with this payment
			INSERT INTO
				tblNachaCabinet
				(
					NachaRegisterID,
					[Type],
					TypeID,
					TrustID
				)
			SELECT
				@nacharegisterid,
				'CommbatchTransferID',
				CommBatchTransferID,
				TrustID
			FROM
				@vtblCommBatches
			WHERE
				CompanyID = @companyid
				and CommRecID = @commrecid
				and ParentCommRecID = @parcommrecid	
				and TrustID = @trustid		
		end
					
		
		fetch next from cursor_CollectionACHCommission into @companyid, @trustid, @commrecid, @recdisplay, @recispersonal, @recroutingnumber, @recaccountnumber, @recaccounttype, @parcommrecid, @pardisplay, @parispersonal, @parroutingnumber, @paraccountnumber, @paraccounttype, @transferamount
	end

	close cursor_CollectionACHCommission
	deallocate cursor_CollectionACHCommission
END TRY
BEGIN CATCH
	close cursor_CollectionACHCommission
	deallocate cursor_CollectionACHCommission

	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH