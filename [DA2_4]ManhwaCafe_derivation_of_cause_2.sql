-- 월 별 이용권 순위 --

-- 먼저 전체 이용권 순위를 알아보자 --
SELECT MENU,
       COUNT(*) AS 판매수
FROM selling_item
WHERE rdate BETWEEN '2023-01-01' AND '2024-04-30'
  AND MENU LIKE '%세트%'
GROUP BY MENU
ORDER BY 판매수 DESC;

-- 주말, 평일로 눠서 확인하기 --
SELECT 
    CASE 
        WHEN s.bWeekday IN (1, 7) THEN '주말'
        ELSE '평일'
    END AS 요일구분,
    si.MENU,
    COUNT(*) AS 판매수
FROM selling s
JOIN selling_item si ON s.s_id = si.s_id
WHERE s.rdate BETWEEN '2023-01-01' AND '2024-04-30'
  AND si.MENU LIKE '%세트%'
GROUP BY 요일구분, si.MENU
ORDER BY 요일구분, 판매수 DESC;

SELECT 
    si.MENU AS 이용권,
    SUM(CASE WHEN s.bWeekday IN (2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS 평일_판매수,
    SUM(CASE WHEN s.bWeekday IN (1, 7) THEN 1 ELSE 0 END) AS 주말_판매수
FROM selling s
JOIN selling_item si ON s.s_id = si.s_id
WHERE s.rdate BETWEEN '2023-01-01' AND '2024-04-30'
  AND si.MENU LIKE '%세트%'
GROUP BY si.MENU
ORDER BY 평일_판매수 DESC, 주말_판매수 DESC;

SELECT 
    DATE_FORMAT(s.rdate, '%Y-%m') AS 월,
    si.MENU AS 이용권,
    SUM(CASE WHEN s.bWeekday IN (2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS 평일_판매수,
    SUM(CASE WHEN s.bWeekday IN (1, 7) THEN 1 ELSE 0 END) AS 주말_판매수
FROM selling s
JOIN selling_item si ON s.s_id = si.s_id
WHERE s.rdate BETWEEN '2023-01-01' AND '2024-04-30'
  AND si.MENU LIKE '%세트%'
GROUP BY 월, si.MENU
ORDER BY 월, 이용권;
