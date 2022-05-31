SET NOCOUNT ON;

-- print 'create tmp-db'

IF OBJECT_ID(N'[nfon].[dbo].[eazybusiness_tmp]',N'U') Is Null
	CREATE TABLE [nfon].[dbo].[eazybusiness_tmp]
	(
		nKundenNr varchar(30),
		nAdresse varchar(30),
		nInetAdresse varchar(30),
		nKunde varchar(30),
		nFirma varchar(100),
		nAnrede varchar(30),
		nTitel varchar(30),
		nVorname varchar(100),
		nName varchar(100),
		nStrasse varchar(100),
		nPLZ varchar(30),
		nOrt varchar(100),
		nLand varchar(100),
		nTel varchar(30),
		nZusatz varchar(100),
		nAdressZusatz varchar(100),
		nPostID varchar(30),
		nMobil varchar(30),
		nMail varchar(100),
		nFax varchar(30),
		nBundesland varchar(100),
		nISO varchar(30),
		nStandard varchar(30),
		nTyp varchar(30),
		nUSTID varchar(30),
		nNotiz varchar(max),
		nBestellung varchar(30),
		nProdukt varchar(max),
		nBestellNr varchar(30)
	);
ELSE
	TRUNCATE TABLE [nfon].[dbo].[eazybusiness_tmp]

-- print 'insert data from wawi in tmp-db'

INSERT INTO [nfon].[dbo].[eazybusiness_tmp]
(nKundenNr,nAdresse,nInetAdresse,nKunde,nFirma,nAnrede,nTitel,nVorname,nName,nStrasse,nPLZ,nOrt,nLand,nTel,nZusatz,nAdressZusatz,nPostID,nMobil,nMail,nFax,nBundesland,nISO,nStandard,nTyp,nUSTID,nNotiz)

SELECT [nfon].[dbo].[eazybusiness_tkunde].[cKundenNr], a.*
FROM [nfon].[dbo].[eazybusiness_tAdresse] a
RIGHT JOIN
(
 SELECT MAX([kAdresse]) AS [kAdresse], [cTel]
 FROM [nfon].[dbo].[eazybusiness_tAdresse]
 GROUP BY [cTel]
 HAVING COUNT([cTel]) < 2
) b
ON a.[kAdresse]=b.[kAdresse] AND a.[cTel]=b.[cTel]

INNER JOIN [nfon].[dbo].[eazybusiness_tkunde]
ON [nfon].[dbo].[eazybusiness_tkunde].[kKunde]=a.kKunde
WHERE a.[cTel] LIKE '0%' OR a.[cTel] LIKE '+%'

DECLARE @nbestellungen TABLE
(
        n_Bestellung varchar(30),
        n_Kunde varchar(30)
);

INSERT INTO @nbestellungen
(n_Bestellung, n_Kunde)

select max(kBestellung) as nBestellung, tKunde_kKunde
from [nfon].[dbo].[eazybusiness_tBestellung]
group by tKunde_kKunde

UPDATE [nfon].[dbo].[eazybusiness_tmp]
SET
[nfon].[dbo].[eazybusiness_tmp].nBestellung = n_Bestellung
FROM @nbestellungen
WHERE [nfon].[dbo].[eazybusiness_tmp].nKunde = n_Kunde

DECLARE @nbestellpos TABLE
(
        tBestellung_kBestellung varchar(30),
        cString varchar(max)
);

INSERT INTO @nbestellpos
(tBestellung_kBestellung, cString)

select tBestellung_kBestellung, CONCAT('Pos ', nSort,': ' ,cString) as cString
From [nfon].[dbo].[eazybusiness_tbestellpos]
WHERE [nfon].[dbo].[eazybusiness_tbestellpos].tBestellung_kBestellung = [nfon].[dbo].[eazybusiness_tbestellpos].tBestellung_kBestellung

DECLARE @nbestellposkom TABLE
(
        tBestellung_kBestellung varchar(30),
        cString varchar(max)
);

INSERT INTO @nbestellposkom
(tBestellung_kBestellung, cString)

select tBestellung_kBestellung, STRING_AGG(CAST(cString AS nvarchar(max)), ', ')
From @nbestellpos
GROUP BY tBestellung_kBestellung

UPDATE [nfon].[dbo].[eazybusiness_tmp]
SET
eazybusiness_tmp.nProdukt = cString
FROM @nbestellposkom
WHERE tBestellung_kBestellung = eazybusiness_tmp.nBestellung

UPDATE [nfon].[dbo].[eazybusiness_tmp]
SET
eazybusiness_tmp.nBestellNr = cBestellNr
FROM [nfon].[dbo].[eazybusiness_tBestellung]
WHERE kBestellung = eazybusiness_tmp.nBestellung

UPDATE [nfon].[dbo].[eazybusiness_tmp]
SET
eazybusiness_tmp.nProdukt = 'Keine Bestellung'
WHERE eazybusiness_tmp.nBestellung is NULL

UPDATE [nfon].[dbo].[eazybusiness_tmp]
SET
eazybusiness_tmp.nNotiz = CONCAT(nKundenNr, ' ', nBestellNr, ' ', nProdukt )
FROM [nfon].[dbo].[eazybusiness_tmp]
WHERE nAdresse = nAdresse

-- select * from [nfon].[dbo].[eazybusiness_tmp]

-- print 'dpo.eazybusiness_tmp fertig - kill all nfon DB-Querys from NCTI'

declare @ToKill table (nummmer VARCHAR(10), session_id varchar(100))
insert into @ToKill

SELECT ROW_NUMBER() OVER(ORDER BY conn.session_id ASC) AS Row#, conn.session_id
FROM sys.dm_exec_sessions AS sess
JOIN sys.dm_exec_connections AS conn
   ON sess.session_id = conn.session_id AND program_name='Connect' AND login_name='nfon'

DECLARE @counter int = 1
DECLARE @end int
DECLARE @KILL int
DECLARE @SessionId int
DECLARE @KilllIt nvarchar(1000)

SELECT @end = COUNT(*) FROM @ToKill

WHILE (@end >= @counter )
BEGIN

    SELECT @SessionId = session_id FROM @ToKill WHERE nummmer = @counter
    SET @KilllIt = 'KILL ' + CAST(@SessionId as varchar(4))
    EXEC (@KilllIt)
    SET @counter = @counter + 1

END

-- print 'copy nfon.dbo.eazybusiness_tmp to nfon.dbo.kontakte'

IF OBJECT_ID(N'[nfon].[dbo].[kontakte]',N'U') Is NOT Null
	DROP TABLE [nfon].[dbo].[kontakte]

select * INTO [nfon].[dbo].[kontakte] FROM [nfon].[dbo].[eazybusiness_tmp]

-- select * FROM [nfon].[dbo].[kbs_tmp]
