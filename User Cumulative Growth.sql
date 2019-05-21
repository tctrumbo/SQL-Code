--This query will show cumulative growth in our user table by utilizing a Temp table for dates and a finely crafted OVER clause

--If the tables exist, drop them
IF OBJECT_ID('tempdb..##Users') IS NOT NULL DROP TABLE ##Users
IF OBJECT_ID('tempdb..##Dates') IS NOT NULL DROP TABLE ##Dates


--Create the User Table
CREATE TABLE ##Users (User_ID varchar(10) not null primary key
,User_Name varchar(255)
,Added_Date datetime)

--Load the user table with data
INSERT INTO ##Users VALUES('TXT','Travis','1/1/2019')
INSERT INTO ##Users VALUES('ADU','Andrew','1/15/2019')
INSERT INTO ##Users VALUES('DBD','Dayna','2/7/2019')
INSERT INTO ##Users VALUES('DBA','Davis','2/10/2019')
INSERT INTO ##Users VALUES('LTW','Latina','2/20/2019')
INSERT INTO ##Users VALUES('MLP','Melissa','3/7/2019')

--Create the dates table
CREATE TABLE ##DATES(Added_Date datetime)

--Load the dates table
DECLARE @startdate date = '1/1/2019'
DECLARE @enddate date= dateadd(dd,+1,getdate())

WHILE @startdate <@enddate
BEGIN
	INSERT INTO ##DATES
	VALUES(@startdate)

	--increment the loop condition
	set @startdate=dateadd(dd,+1,@startdate)
END


--GET THE DATA!
SELECT cast(x.added_date as date) as date,sum(x.users_added) OVER (order by added_date) as cumulative_users
FROM
(
	SELECT a.added_date,count(b.user_id) as users_added
	FROM ##DATES a 
	LEFT OUTER JOIN ##Users b on a.Added_Date = cast(b.added_Date as date) --User added_Date column is a datetime, we must cast to date
	group by a.Added_Date
)x
order by added_Date