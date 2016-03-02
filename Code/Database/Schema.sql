USE [JetStreamJetstream_Analytics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************* Drop SPs - BEGIN *********************/

DROP PROCEDURE [dbo].[Add_RegistrationReferrals_Tvp]
GO

DROP PROCEDURE [dbo].[Add_RegistrationReferrals]
GO

DROP PROCEDURE [dbo].[Ensure_ReferralSources_Tvp]
GO

DROP PROCEDURE [dbo].[Ensure_ReferralSources]
GO

/******************* Drop SPs - END ***********************/


/******************* Drop Views - BEGIN *********************/

DROP VIEW [dbo].[RegistrationReferrals]
GO

/******************* Drop Views - END ***********************/


/******************* Drop Constraints - BEGIN *********************/

ALTER TABLE [dbo].[Fact_RegistrationReferrals] DROP CONSTRAINT [FK_Fact_RegistrationReferrals_SiteNames]
GO

ALTER TABLE [dbo].[Fact_RegistrationReferrals] DROP CONSTRAINT [FK_Fact_RegistrationReferrals_ReferralSources]
GO

/******************* Drop Constraints - END ***********************/


/******************* Drop Tables - BEGIN *********************/

DROP TABLE [dbo].[ReferralSources]
GO

DROP TABLE [dbo].[Fact_RegistrationReferrals]
GO

/******************* Drop Tables - END ***********************/


/******************* Create Tables - BEGIN *********************/

CREATE TABLE [dbo].[ReferralSources](
	[ReferralSourceId] [int] NOT NULL,
	[ReferralSource] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ReferralSources] PRIMARY KEY CLUSTERED 
(
	[ReferralSourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Fact_RegistrationReferrals](
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[ReferralSourceId] [int] NOT NULL,
	[Count] [bigint] NOT NULL
 CONSTRAINT [PK_Fact_RegistrationReferrals] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[SiteNameId] ASC,
	[ReferralSourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/******************* Create Tables - END ***********************/


/******************* Create Constraints - BEGIN *********************/

ALTER TABLE [dbo].[Fact_RegistrationReferrals]  WITH NOCHECK ADD  CONSTRAINT [FK_Fact_RegistrationReferrals_SiteNames] FOREIGN KEY([SiteNameId])
REFERENCES [dbo].[SiteNames] ([SiteNameId])
GO

ALTER TABLE [dbo].[Fact_RegistrationReferrals] NOCHECK CONSTRAINT [FK_Fact_RegistrationReferrals_SiteNames]
GO

ALTER TABLE [dbo].[Fact_RegistrationReferrals]  WITH NOCHECK ADD  CONSTRAINT [FK_Fact_RegistrationReferrals_ReferralSources] FOREIGN KEY([ReferralSourceId])
REFERENCES [dbo].[ReferralSources] ([ReferralSourceId])
GO

ALTER TABLE [dbo].[Fact_RegistrationReferrals] NOCHECK CONSTRAINT [FK_Fact_RegistrationReferrals_ReferralSources]
GO

/******************* Create Constraints - END ***********************/


/******************* TVPs - BEGIN *********************/

DROP TYPE [dbo].[RegistrationReferrals_Type]
GO

CREATE TYPE [dbo].[RegistrationReferrals_Type] AS TABLE(
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[ReferralSourceId] [int] NOT NULL,
	[Count] [bigint] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[SiteNameId] ASC,
	[ReferralSourceId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

DROP TYPE [dbo].[ReferralSources_Type]
GO

CREATE TYPE [dbo].[ReferralSources_Type] AS TABLE(
	[ReferralSourceId] [int] NOT NULL,
	[ReferralSource] [nvarchar](100) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[ReferralSourceId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

/******************* TVPs - END ***********************/


/******************* Create SPs - BEGIN *********************/

CREATE PROCEDURE [dbo].[Add_RegistrationReferrals_Tvp]
  @table [RegistrationReferrals_Type] READONLY
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_RegistrationReferrals] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source]
    ON
    (
      ([target].[Date] = [source].[Date]) AND
      ([target].[SiteNameId] = [source].[SiteNameId]) AND
      ([target].[ReferralSourceId] = [source].[ReferralSourceId])
    )
    WHEN MATCHED THEN
      UPDATE
        SET
        [target].[Count] = ([target].[Count] + [source].[Count])
    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [SiteNameId],
        [ReferralSourceId],
        [Count]
      )
      VALUES
      (
        [source].[Date],
        [source].[SiteNameId],
        [source].[ReferralSourceId],
        [source].[Count]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

  END CATCH;
END;

GO


CREATE PROCEDURE [dbo].[Add_RegistrationReferrals]
  @Date SMALLDATETIME,
  @SiteNameId INTEGER,
  @ReferralSourceId INTEGER,
  @Count BIGINT
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

	MERGE
    [Fact_RegistrationReferrals] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @SiteNameId,
      @ReferralSourceId,
      @Count
    )
  )
  AS [source]
  (
    [Date],
    [SiteNameId],
    [ReferralSourceId],
    [Count]
  )
  ON
  (
    ([target].[Date] = [source].[Date]) AND
    ([target].[SiteNameId] = [source].[SiteNameId]) AND
    ([target].[ReferralSourceId] = [source].[ReferralSourceId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
      [target].[Count] = ([target].[Count] + [source].[Count])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [SiteNameId],
      [ReferralSourceId],
      [Count]
    )
    VALUES
    (
      [source].[Date],
      [source].[SiteNameId],
      [source].[ReferralSourceId],
      [source].[Count]
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_RegistrationReferrals]
      SET
        [Count] = ([Count] + @Count)
      WHERE
        ([Date] = @Date) AND
        ([SiteNameId] = @SiteNameId) AND
        ([ReferralSourceId] = @ReferralSourceId);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_RegistrationReferrals] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;
END;

GO


CREATE PROCEDURE [dbo].[Ensure_ReferralSources_Tvp]
  @table [ReferralSources_Type] READONLY
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [ReferralSources] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[ReferralSourceId] = [source].[ReferralSourceId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [ReferralSourceId],
      [ReferralSource]
    )
    VALUES
    (
      [source].[ReferralSourceId],
      [source].[ReferralSource]
    );

END;

GO

CREATE PROCEDURE [dbo].[Ensure_ReferralSources]
  @ReferralSourceId INTEGER,
  @ReferralSource NVARCHAR(100)
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [ReferralSources]
    (
      [ReferralSourceId],
      [ReferralSource]
    )
    VALUES
    (
      @ReferralSourceId,
      @ReferralSource
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;

GO

/******************* Create SPs - END ***********************/


/******************* Create Views - BEGIN *********************/

CREATE VIEW [dbo].[RegistrationReferrals]
AS
SELECT
  [Fact_RegistrationReferrals].[Date] AS [Date],
  CAST( DATEADD( DAY, (-DATEPART( DAY, [Fact_RegistrationReferrals].[Date] ) + 1), [Fact_RegistrationReferrals].[Date] ) AS DATE) AS [Month],
  LOWER( [SiteNames].[SiteName] ) AS [Site],
  LOWER( [ReferralSources].[ReferralSource] ) AS [ReferralSource],
  [Fact_RegistrationReferrals].[Count] AS [NumberOfRegistrations]
FROM
  [Fact_RegistrationReferrals]
  INNER JOIN [SiteNames] ON ([Fact_RegistrationReferrals].[SiteNameId] = [SiteNames].[SiteNameId])
  INNER JOIN [ReferralSources] ON ([Fact_RegistrationReferrals].[ReferralSourceId] = [ReferralSources].[ReferralSourceId]);

GO

/******************* Create Views - END ***********************/
