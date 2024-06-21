-- 원인 도출 --

-- 1. 학교 단체 손님 방문이 늘었으나, 객단가가 낮아서 --
-- 검증1. 월 별 평균 객단가 분석 --
SELECT * 
FROM selling
WHERE rdate BETWEEN '2022-01-01' AND '2024-04-30'
ORDER BY time_modified, st_id; ## price_tot/customer_no로 객단가를 구하려 했는데 둘이 와서 따로 결제하면 처음 계산한 사람은 기존 명 수로 기록이 남아있다.

SELECT *
FROM selling_item
WHERE s_id = '109090'
OR s_id = '109089'; # 위 데이터 확인 코드

-- 평균 객단가를 구하는 거니까 월 별로 매출에서 방문자 수로 나누어서 계산하는 것도 괜찮을 것 같다.--
-- 2022, 2023년, 2024년의 월별 객단가  --
SELECT 
    MONTH(s.rdate) AS month,
	SUM(CASE WHEN YEAR(s.rdate) = 2022 THEN s.price_tot ELSE 0 END) / 
		SUM(CASE WHEN YEAR(s.rdate) = 2022 THEN (
			SELECT COUNT(si.no) 
			FROM selling_item si 
			WHERE si.s_id = s.s_id
			AND si.MENU LIKE '%세트%'
		) ELSE 0 END) AS avg_price_per_customer_2022,
    SUM(CASE WHEN YEAR(s.rdate) = 2023 THEN s.price_tot ELSE 0 END) / 
		SUM(CASE WHEN YEAR(s.rdate) = 2023 THEN (
			SELECT COUNT(si.no) 
			FROM selling_item si 
			WHERE si.s_id = s.s_id
			AND si.MENU LIKE '%세트%'
		) ELSE 0 END) AS avg_price_per_customer_2023,
    SUM(CASE WHEN YEAR(s.rdate) = 2024 THEN s.price_tot ELSE 0 END) / 
		SUM(CASE WHEN YEAR(s.rdate) = 2024 THEN (
			SELECT COUNT(si.no) 
			FROM selling_item si 
			WHERE si.s_id = s.s_id
			AND si.MENU LIKE '%세트%'
		) ELSE 0 END) AS avg_price_per_customer_2024
FROM selling s
WHERE s.rdate BETWEEN '2022-01-01' AND '2024-04-30'
GROUP BY MONTH(s.rdate)
ORDER BY month;


-- 검증2. 2024-3월 내, 단체 유무에 따른 객단가 비교 --
-- 2024년 3월 객단가 --
SELECT date,
	   SUM(price_tot) / COUNT(DISTINCT s_id) AS AOV_202403
FROM (SELECT DATE(s.rdate) AS date,
			 s.s_id,
             s.price_tot,
             (SELECT COUNT(si.no) 
             FROM selling_item si
             WHERE si.s_id = s.s_id
             AND si.MENU LIKE '%세트%') AS set_menu_count
    FROM selling s
    WHERE s.rdate BETWEEN '2024-03-01' AND '2024-03-31'
	) AS subquery
WHERE set_menu_count > 0
GROUP BY date
ORDER BY date;

-- 2024.4월 객단가( 단체가 더 많음 )
SELECT date,
	   SUM(price_tot) / COUNT(DISTINCT s_id) AS AOV_202403
FROM (SELECT DATE(s.rdate) AS date,
			 s.s_id,
             s.price_tot,
             (SELECT COUNT(si.no) 
             FROM selling_item si
             WHERE si.s_id = s.s_id
             AND si.MENU LIKE '%세트%') AS set_menu_count
    FROM selling s
    WHERE s.rdate BETWEEN '2024-04-01' AND '2024-04-30'
	) AS subquery
WHERE set_menu_count > 0
GROUP BY date
ORDER BY date;