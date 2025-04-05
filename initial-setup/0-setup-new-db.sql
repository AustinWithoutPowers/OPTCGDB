-- CREATE DATABASE [OPTCGDB] COLLATE Latin1_General_CI_AI;
-- GO

USE [OPTCGDB];
GO

DROP TABLE IF EXISTS [CardTypeLinks];
DROP TABLE IF EXISTS [Cards];
DROP TABLE IF EXISTS [Sets];
DROP TABLE IF EXISTS [SetTypes];
DROP TABLE IF EXISTS [CardGroups];
DROP TABLE IF EXISTS [Colours];
DROP TABLE IF EXISTS [Rarities];
DROP TABLE IF EXISTS [Attributes];
DROP TABLE IF EXISTS [CardTypes];

CREATE TABLE [CardTypes] (
	[CardTypeID] INT IDENTITY(0, 1) NOT NULL UNIQUE,
	[CardTypeName] NVARCHAR(32)
)

CREATE TABLE [Attributes] (
	[AttributeID] NCHAR NOT NULL UNIQUE,
	[AttributeName] NVARCHAR(32) NOT NULL
)

CREATE TABLE [Rarities] (
	RarityID NVARCHAR(4) NOT NULL UNIQUE,
	RarityName NVARCHAR(32) NOT NULL
)

CREATE TABLE [Colours] (
	[ColourID] NCHAR NOT NULL UNIQUE,
	[ColourName] NVARCHAR(16) NOT NULL,
	CONSTRAINT [PK_Colours] PRIMARY KEY ([ColourID])
)

CREATE TABLE [CardGroups] (
	[CardGroupID] INT IDENTITY(0, 1) NOT NULL UNIQUE,
	[CardGroupName] NVARCHAR(32) NOT NULL,
	CONSTRAINT [PK_CardGroups] PRIMARY KEY ([CardGroupID])
)

CREATE TABLE [SetTypes] (
	[SetTypeID] INT IDENTITY(0, 1) NOT NULL UNIQUE,
	[SetTypeName] NVARCHAR(64) NOT NULL,
	[SetTypeShortCode] NVARCHAR(16) NOT NULL,
	CONSTRAINT [PK_SetTypes] PRIMARY KEY ([SetTypeID])
)

CREATE TABLE [Sets] (
	[SetID] INT IDENTITY(0, 1) NOT NULL UNIQUE,
	[SetName] NVARCHAR(64) NOT NULL,
	[SetCode] NVARCHAR(16) NOT NULL,
	[SetTypeID] INT,
	[ReleaseDate] DATE,
	CONSTRAINT [PK_Sets] PRIMARY KEY ([SetID]),
	CONSTRAINT [FK_Sets_SetTypes] FOREIGN KEY ([SetTypeID]) REFERENCES [SetTypes] ([SetTypeID])
)

CREATE TABLE [Cards] (
	[CardID] NVARCHAR(16) NOT NULL UNIQUE,
	[CardName] NVARCHAR(64) NOT NULL,
	[SetID] INT NOT NULL,
	[CardGroupID] INT NOT NULL,
	[ColourID] NCHAR NOT NULL,
	[SecondColourID] NCHAR NULL,
	[Cost] SMALLINT NULL,
	[Power] INT NULL,
	[Life] SMALLINT NULL,
	[CounterValue] INT NULL, -- Need to consider counter events?
	[Counter] BIT NULL, -- Considered.
	[Blocker] BIT NULL,
	[EffectText] NVARCHAR(256), -- Hope this is enough...?
	[RarityID] NVARCHAR(4) NOT NULL,
	[AltArt] BIT NOT NULL, -- Unsure if we need to change this to be nullable...?
	[AttributeID] NCHAR NOT NULL,
	CONSTRAINT [PK_Cards] PRIMARY KEY ([CardID]),
	CONSTRAINT [FK_Cards_Sets] FOREIGN KEY ([SetID]) REFERENCES [Sets] ([SetID]),
	CONSTRAINT [FK_Cards_CardGroups] FOREIGN KEY ([CardGroupID]) REFERENCES [CardGroups] ([CardGroupID]),
	CONSTRAINT [FK_Cards_Colours] FOREIGN KEY ([ColourID]) REFERENCES [Colours] ([ColourID]),
	CONSTRAINT [FK_Cards_Colours_Second] FOREIGN KEY ([ColourID]) REFERENCES [Colours] ([ColourID]),
	CONSTRAINT [FK_Cards_Rarities] FOREIGN KEY ([RarityID]) REFERENCES [Rarities] ([RarityID]),
	CONSTRAINT [FK_Cards_Attributes] FOREIGN KEY ([AttributeID]) REFERENCES [Attributes] ([AttributeID])
)

CREATE TABLE [CardTypeLinks] (
	[CardID] NVARCHAR(16) NOT NULL,
	[CardTypeID] INT NOT NULL,
	CONSTRAINT [PK_CardTypeLinks] PRIMARY KEY ([CardID], [CardTypeID]),
	CONSTRAINT [FK_CardTypeLinks_CardID] FOREIGN KEY ([CardID]) REFERENCES [Cards] ([CardID]),
	CONSTRAINT [FK_CardTypeLinks_CardTypeID] FOREIGN KEY ([CardTypeID]) REFERENCES [CardTypes] ([CardTypeID])
)

SELECT GETDATE() AS [GETDATE( )]