﻿IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Payroll')
BEGIN
CREATE DATABASE [Payroll] ON  PRIMARY 
( NAME = N'Payroll', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Payroll.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Payroll_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Payroll_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
END

GO
EXEC dbo.sp_dbcmptlevel @dbname=N'Payroll', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Payroll].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [Payroll] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Payroll] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Payroll] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Payroll] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Payroll] SET ARITHABORT OFF 
GO
ALTER DATABASE [Payroll] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Payroll] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Payroll] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Payroll] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Payroll] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Payroll] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Payroll] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Payroll] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Payroll] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Payroll] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Payroll] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Payroll] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Payroll] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Payroll] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Payroll] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Payroll] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Payroll] SET  READ_WRITE 
GO
ALTER DATABASE [Payroll] SET RECOVERY FULL 
GO
ALTER DATABASE [Payroll] SET  MULTI_USER 
GO
ALTER DATABASE [Payroll] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Payroll] SET DB_CHAINING OFF  