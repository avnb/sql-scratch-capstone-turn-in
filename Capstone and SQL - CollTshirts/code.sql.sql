--1. Count the number of campagins, sources and related them:

-- Number of distinct campaigns

SELECT COUNT(DISTINCT utm_campaign) as 'Campaign Count'
FROM page_visits;

-- Number of distinct sources

SELECT COUNT(DISTINCT utm_source) as 'Source Count'
FROM page_visits;

-- Relationship between a campaign and its sources

SELECT DISTINCT utm_campaign as 'Campaign',
utm_source as 'Source'
FROM page_visits;


--2. Distinct pages in the CollTShirts website

--First touches by user id

SELECT DISTINCT page_name as 'Page Name'
FROM page_visits;

--3. Count the number of first touches per campaign

--Temporary table with first touches by user id

WITH first_touch AS (SELECT user_id, MIN(timestamp) as first_touch_at
                     FROM page_visits
                     GROUP BY user_id),
     
--Temporary table with timestamp and user_id from page_visits

ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)

--Count the number of rows where a specific source is associated with the same campaign

SELECT ft_attr.utm_source AS 'Source',
       ft_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Count'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--4. Count the number of last touches per campaign

--Temporary table with last touches by user id

WITH last_touch AS (SELECT user_id, MAX(timestamp) as last_touch_at
                     FROM page_visits
                     GROUP BY user_id),
     
--Temporary table with timestamp and user_id from page_visits

lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)

--Count the number of rows where a specific source is associated with the same campaign

SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--5.Count the number of visitors who made purchases

SELECT COUNT(DISTINCT user_id) AS 'Visitors that made a purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

--6. Count how many last touches on the purchase page is each campaign 
--responsible for

--Temporary table with last touches by user id in page '4 - purchase'
                  
    WITH last_touch AS (
  SELECT user_id,
         MAX(timestamp) AS last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),

--Temporary table with timestamp and user_id from page_visits

lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)

--Count the number of rows where a specific source is associated with 
--the same campaign

SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
