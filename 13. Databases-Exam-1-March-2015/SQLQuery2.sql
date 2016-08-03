USE Geography

--Task 1

SELECT p.PeakName
FROM Peaks p
ORDER BY p.PeakName

--Task 2

SELECT TOP 30 c.CountryName,c.Population
FROM Countries c
WHERE c.ContinentCode='EU'
ORDER BY c.Population DESC

--Task 3

SELECT 
  c.CountryName,
  c.CountryCode,
(CASE c.CurrencyCode WHEN 'EUR' THEN 'Euro' ELSE 'Not Euro' END) AS [Currency]
FROM Countries c
ORDER BY c.CountryName

--Task 4

SELECT 
c.CountryName AS [Country Name],
c.IsoCode AS [ISO Code]
FROM Countries c
WHERE c.CountryName LIKE '%A%A%A%'
ORDER BY c.IsoCode

--Task 5

SELECT
  p.PeakName,
  m.MountainRange AS [Mountain],
  p.Elevation AS [Elevation]
FROM Peaks p
INNER JOIN Mountains m
  ON p.MountainId=m.Id
ORDER BY p.Elevation DESC

--Task 6

SELECT
  p.PeakName,
  m.MountainRange AS [Mountain],
  c.CountryName,
  con.ContinentName
FROM Peaks p
INNER JOIN Mountains m
  ON p.MountainId=m.Id
INNER JOIN MountainsCountries mc
  ON m.Id=mc.MountainId
INNER JOIN Countries c
  ON mc.CountryCode=c.CountryCode
INNER JOIN Continents con
  ON con.ContinentCode=c.ContinentCode
ORDER BY p.PeakName,c.CountryName

--Task 7

SELECT 
  r.RiverName AS [River],
  COUNT(c.CountryCode) AS [Countries Count]
FROM Rivers r
INNER JOIN CountriesRivers cr
  ON r.Id=cr.RiverId
INNER JOIN Countries c
  ON cr.CountryCode=c.CountryCode
GROUP BY r.RiverName 
HAVING COUNT(c.CountryCode)>=3
ORDER BY r.RiverName

--Task 8

SELECT 
  MAX(p.Elevation) AS [MaxElevation],
  MIN(p.Elevation) AS [MinElevation],
  AVG(p.Elevation) AS [AverageElevation]
FROM Peaks p

--Task 9

SELECT
  c.CountryName,
  con.ContinentName,
  COUNT(r.Id) AS [RiversCount],
  ISNULL(SUM(r.Length),0) AS [TotalLength]
FROM Countries c
LEFT OUTER JOIN CountriesRivers cr
  ON c.CountryCode=cr.CountryCode
LEFT OUTER JOIN Rivers r
  ON cr.RiverId=r.Id
LEFT OUTER JOIN Continents con
  ON c.ContinentCode=con.ContinentCode
GROUP BY c.CountryName,con.ContinentName
ORDER BY [RiversCount] DESC,[TotalLength] DESC,c.CountryName

--Task 10

SELECT 
  cur.CurrencyCode,
  cur.Description AS [Currency],
  COUNT(c.CountryCode) AS [NumberOfCountries]
FROM Currencies cur
LEFT OUTER JOIN Countries c
  ON cur.CurrencyCode=c.CurrencyCode
GROUP BY cur.CurrencyCode,cur.Description
ORDER BY NumberOfCountries DESC,Currency ASC

--Task 11

SELECT 
  con.ContinentName,
  SUM(CONVERT(bigint,c.AreaInSqKm)) AS CountriesArea,
  SUM(CONVERT(bigint,c.Population)) AS [CountriesPopulation]
FROM Continents con
INNER JOIN Countries c
  ON c.ContinentCode=con.ContinentCode
GROUP BY con.ContinentName
ORDER BY CountriesPopulation DESC

--Task 12

SELECT
  c.CountryName,
  MAX(p.Elevation) AS [HighestPeakElevation],
  MAX(r.Length) AS [LongestRiverLength]
FROM Countries c
LEFT OUTER JOIN CountriesRivers cr
  ON cr.CountryCode=c.CountryCode
LEFT OUTER JOIN Rivers r
  On r.Id=cr.RiverId
LEFT OUTER JOIN MountainsCountries mc
  ON mc.CountryCode=c.CountryCode
LEFT OUTER JOIN Mountains m
 ON m.Id=mc.MountainId
LEFT OUTER JOIN Peaks p
  ON p.MountainId=m.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC,LongestRiverLength DESC,c.CountryName ASC

--Task 13

SELECT 
  p.PeakName,
  r.RiverName,
  LOWER(SUBSTRING(p.PeakName,1,LEN(p.PeakName)-1))+LOWER(r.RiverName) AS [Mix]
FROM Peaks p,Rivers r
WHERE RIGHT(p.PeakName,1)=LEFT(r.RiverName,1)
ORDER BY Mix

--Task 14

SELECT
  c.CountryName AS [Country],
  p.PeakName AS [Highest Peak Name],
  p.Elevation AS [Highest Peak Elevation],
  m.MountainRange AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE p.Elevation =
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode)
UNION
SELECT
  c.CountryName AS [Country],
  '(no highest peak)' AS [Highest Peak Name],
  0 AS [Highest Peak Elevation],
  '(no mountain)' AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE 
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode) IS NULL
ORDER BY c.CountryName, [Highest Peak Name]

--Task 15

CREATE TABLE Monasteries(
  ID int IDENTITY,
  Name nvarchar(50) NOT NULL,
  CountryCode char(2) NOT NULL,
  CONSTRAINT FK_Monasteries_Countries FOREIGN KEY(CountryCode) REFERENCES Countries(CountryCode))

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

ALTER TABLE Countries
ADD IsDeleted bit NOT NULL
DEFAULT 0

UPDATE Countries
SET IsDeleted=1
WHERE CountryCode IN (
	SELECT c.CountryCode
    FROM Countries c
	INNER JOIN CountriesRivers cr
	  ON cr.CountryCode=c.CountryCode
	INNER JOIN Rivers r
	  ON r.Id=cr.RiverId
	GROUP BY c.CountryCode
	HAVING COUNT(r.Id)>3
	  )

SELECT 
  m.Name AS [Monastery],
  c.CountryName AS [Country]
FROM Monasteries m
INNER JOIN Countries c
 ON c.CountryCode=m.CountryCode
WHERE c.IsDeleted=0
ORDER BY m.Name

--Task 16

UPDATE Countries
SET CountryName='Burma'
WHERE CountryName='Myanmar'

INSERT INTO Monasteries(Name,CountryCode)
VALUES ('Hanga Abbey',(SELECT CountryCode FROM Countries WHERE CountryName='Tanzania'))

INSERT INTO Monasteries(Name,CountryCode)
VALUES ('Myin-Tin-Daik',(SELECT CountryCode FROM Countries WHERE CountryName='Myanmar'))

SELECT
  co.ContinentName,
  c.CountryName,
  COUNT(m.ID) AS [MonasteriesCount]
FROM Continents co
LEFT OUTER JOIN Countries c
  ON c.ContinentCode=co.ContinentCode
LEFT OUTER JOIN Monasteries m
  ON m.CountryCode=c.CountryCode
WHERE c.IsDeleted=0
GROUP BY co.ContinentName,c.CountryName
ORDER BY MonasteriesCount DESC,c.CountryName