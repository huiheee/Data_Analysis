-- 현황 파악

 -- 1. 월 별 매출 확인 --
 SELECT *
 FROM selling
 WHERE rdate BETWEEN '2022-01-01' AND '2024-04-30';
 
SELECT DATE_FORMAT(rdate, '%y-%m') AS month,
	   SUM(price_tot) AS sales
FROM selling
WHERE rdate BETWEEN '2022-01-01' AND '2024-04-30'
GROUP BY month;
 
SELECT month(rdate) AS month,
		SUM(CASE WHEN YEAR(rdate) = '2022' THEN price_tot ELSE 0 END) AS 2022_sales,
		SUM(CASE WHEN YEAR(rdate) = '2023' THEN price_tot ELSE 0 END) AS 2023_sales,
        SUM(CASE WHEN YEAR(rdate) = '2024' THEN price_tot ELSE 0 END) AS 2024_sales
FROM selling
WHERE rdate BETWEEN '2022-01-01' AND '2024-04-30'
GROUP BY MONTH(rdate)
ORDER BY MONTH(rdate);
 
 
 -- 2. 월 별 이용자 추이 --
 SELECT *
 FROM selling_item
 WHERE rdate BETWEEN '2022-01-01' AND '2024-04-30'
 AND MENU LIKE '%세트%';

SELECT *
FROM selling
WHERE s_id = '109093'
OR s_id = '109094';


-- 년월 별 방문자 수 --
SELECT DATE_FORMAT(rdate, '%Y-%m') AS month,
	   SUM(no) AS count
FROM selling_item
WHERE rdate BETWEEN '2022-01-01' AND '2024-04-30'
AND MENU LIKE '%세트%'
GROUP BY month
ORDER BY month;

SELECT DATE_FORMAT(rdate, '%Y-%m') AS month,
	   SUM(no) AS count
FROM selling_item2
WHERE rdate BETWEEN '2023-01-01' AND '2024-04-30'
GROUP BY month
ORDER BY month;

-- 년/월 나워서 방문자 확인 --
SELECT 
    MONTH(rdate) AS month,
	SUM(CASE WHEN YEAR(rdate) = 2022 THEN no ELSE 0 END) AS count_2022,
    SUM(CASE WHEN YEAR(rdate) = 2023 THEN no ELSE 0 END) AS count_2023,
    SUM(CASE WHEN YEAR(rdate) = 2024 THEN no ELSE 0 END) AS count_2024
FROM selling_item2
WHERE MENU LIKE '%세트%'
AND rdate BETWEEN '2022-01-01' AND '2024-04-30'
GROUP BY MONTH(rdate)
ORDER BY MONTH(rdate);
