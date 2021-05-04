 USE [master]
GO
/****** Object:  Database [ClientStatementArchive]    Script Date: 01/05/2011 08:32:49 ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ClientStatementArchive')
BEGIN
CREATE DATABASE [ClientStatementArchive] ON  PRIMARY 
( NAME = N'ClientStatementArchive', FILENAME = N'E:\Microsoft SQL Server\MSSQL.1\MSSQL\Data\ClientStatementArchive.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ClientStatementArchive_log', FILENAME = N'F:\Microsoft SQL Server\MSSQL.1\MSSQL\Data\ClientStatementArchive_log.ldf' , SIZE = 24576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
END

GO
EXEC dbo.sp_dbcmptlevel @dbname=N'ClientStatementArchive', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ClientStatementArchive].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [ClientStatementArchive] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET ARITHABORT OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ClientStatementArchive] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ClientStatementArchive] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ClientStatementArchive] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ClientStatementArchive] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ClientStatementArchive] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ClientStatementArchive] SET  READ_WRITE 
GO
ALTER DATABASE [ClientStatementArchive] SET RECOVERY FULL 
GO
ALTER DATABASE [ClientStatementArchive] SET  MULTI_USER 
GO
ALTER DATABASE [ClientStatementArchive] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ClientStatementArchive] SET DB_CHAINING OFF 