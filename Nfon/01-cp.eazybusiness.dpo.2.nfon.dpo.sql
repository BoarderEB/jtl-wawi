SET NOCOUNT ON;

-- print 'copy wawi to nfon-tmp'

IF OBJECT_ID(N'[nfon].[dbo].[eazybusiness_tkunde]',N'U') Is NOT Null
	DROP TABLE [nfon].[dbo].[eazybusiness_tkunde]

IF OBJECT_ID(N'[nfon].[dbo].[eazybusiness_tAdresse]',N'U') Is NOT Null
	DROP TABLE [nfon].[dbo].[eazybusiness_tAdresse]

IF OBJECT_ID(N'[nfon].[dbo].[eazybusiness_tBestellung]',N'U') Is NOT Null
	DROP TABLE [nfon].[dbo].[eazybusiness_tBestellung]

IF OBJECT_ID(N'[nfon].[dbo].[eazybusiness_tbestellpos]',N'U') Is NOT Null
	DROP TABLE [nfon].[dbo].[eazybusiness_tbestellpos]

select * INTO [nfon].[dbo].[eazybusiness_tkunde] FROM [eazybusiness].[dbo].[tkunde]
select * INTO [nfon].[dbo].[eazybusiness_tAdresse] FROM [eazybusiness].[dbo].[tAdresse]
select * INTO [nfon].[dbo].[eazybusiness_tBestellung] FROM [eazybusiness].[dbo].[tBestellung]
select * INTO [nfon].[dbo].[eazybusiness_tbestellpos] FROM [eazybusiness].[dbo].[tbestellpos]
