## International Football Project 
## Q1- What nation had the most wins by decade since 1922.
## Q2- How much does home field advantage help?
## Q3- Top goal scorers in international football?
--
## I got the data from Kaggle. Downloaded the CVS file and uploaded to MySQL workbench. 
## I started off by looking through each of the tables to understand the lay out of each. 
SELECT *
FROM football.results
## Time to clean the data.
## Checked for duplicate data, and for NULLs
## Relevant data, I wanted to look at the last 100 years of football for wins 
## Prior to the 1920s the game was less organized and became global with the 1930 world cup.  
SELECT *
FROM football.results
## 44353 rows returned 
SELECT distinct *
FROM football.results
## 44353 rows returned, followed same procedure for two other tables 
## Unique rows for shootouts matched all rows for shootouts. 
## Rows returned for distinct goalscorer rows was less than the total. Ran the query below to dig in more. 
SELECT 
date, count(date),
scorer, count(scorer),
minute, count(minute)
FROM football.goalscorers
GROUP BY
date, 
scorer,
minute
HAVING count(date) > 1
AND count(scorer) > 1
AND count(minute) > 1
## After doing more research, the column for minute scored was not accounting for injury time. 
## So, goals that were scored in a game that was not in over time Ex. 92' of injury time counted as the 90th minute. Kept all data. 
## Checked for nulls for all columns in all tables. Must be a faster way to check for NULLs in entire table. 
SELECT *
FROM football.shootouts
WHERE winner IS NULL 
## I changed the date coloumn from string to date. Later realized I did not need to do so. 
SELECT *, str_to_date(date, '%Y-%m-%d') as new_date
FROM football.results
## Queries to show games played starting in 1922. 
SELECT *
FROM football.results
WHERE date >= '1922-01-01'
--
SELECT * 
FROM football.goalscorers
WHERE date >= '1922-01-01'
--
SELECT * 
FROM football.shootouts
WHERE date >= '1922-01-01'
## Created vies to simplify the analyzing processes 
## ended up not using this one
CREATE VIEW match_details as 
SELECT r.date,
r.home_team,
r.away_team,
r.home_score,
r.away_score, 
g.scorer,
g.minute
FROM results r
JOIN goalscorers g
	ON r.date = g.date
WHERE r.date >= '1922-01-01'
 ## Test the view
 Select *
 FROM match_details
 ## create VIEW with column showing winner of match
CREATE VIEW match_result as
Select *,
CASE
WHEN home_score > away_score THEN home_team
WHEN away_score > home_score THEN away_team
ELSE 'tie'
END as match_result
 FROM results
 ## test the view
 SELECT *
 FROM match_result
 ## Ran a few queries to see who has the most wins 
 ## 	QUESTION 1 anwswered
 ## most wins from 1922-1930-- SWEDEN
 SELECT match_result, count(match_result) AS winner 
 FROM match_result
 WHERE date BETWEEN '1922-01-01' and '1929-12-31'
 GROUP BY match_result
 ORDER BY winner
 ## most wins from 1930- 1940 -- GERMANY
 ## most wins from 1940-1950-- ARGENTINA
 ## most wins from 1950-1960-- BRAZIL
 ## most wins from 1960-1970-- BRAZIL
 ## most wins from 1970-1980-- SOUTH KOREA
 ## most wins from 1980-1990-- SOUTH KOREA
 ## most wins from 1990-2000-- BRAZIL
 ## most wins from 2000-2010- SAUDI ARABIA
 ## most wins from 2010-2020-- MEXICO
 SELECT match_result, count(match_result) AS winner 
 FROM match_result
 WHERE date BETWEEN '2010-01-01' and '2019-12-31'
 GROUP BY match_result
 ORDER BY winner
 -- Q2
## Calculating win percentage
SELECT count(*) AS total_matches,
count(CASE WHEN match_result = home_team THEN 1 else null end) AS home_win, 
count(CASE WHEN match_result = away_team THEN 1 else null end) AS away_win
FROM match_result
## use of subquery to find win percentage away and home
SELECT (a.away_win/a.total_matches *100) AS away_win_percent,
(a.home_win/a.total_matches *100) AS home_win_percent
FROM (SELECT count(*) as total_matches,
count(CASE WHEN match_result = home_team THEN 1 ELSE NULL END) AS home_win, 
count(CASE WHEN match_result = away_team THEN 1 ELSE NULL END) AS away_win
FROM match_result) AS a
##		QUESTION 2 ANSWERED 
## home teams enjoy a win percentage of 48.71%,
## away teams is much lower @ 28.27%
-- Q3	
## who is in the top 5 the most international goals 
SELECT scorer, count(*) as goals
FROM goalscorers 
GROUP BY scorer
ORDER BY goals desc
LIMIT 5
## 		QUESTION 3 ANSWERED 
##	Ronaldo has the most international goals with 91




