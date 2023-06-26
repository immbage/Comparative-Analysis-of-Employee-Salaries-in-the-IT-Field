SELECT * FROM ds_salaries;

-- 1. Check whether there is NULL data
SELECT * FROM ds_salaries
WHERE
	work_year IS NULL
	OR experience_level IS NULL
	OR employment_type IS NULL
	OR job_title IS NULL
	OR salary IS NULL
	OR salary_currency IS NULL
	OR salary_in_usd IS NULL
	OR employee_residence IS NULL
	OR remote_ratio IS NULL
	OR company_location IS NULL
	OR company_size IS NULL;

-- 2. Check what jobs are there
SELECT DISTINCT job_title
FROM ds_salaries
ORDER BY job_title;

-- 3. Check what jobs are related to data analyst
SELECT DISTINCT job_title
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
ORDER BY job_title;

-- 4. Check how much the average data analyst salary is
SELECT AVG(salary_in_usd) AS avg_salary_in_usd
FROM ds_salaries
WHERE job_title LIKE '%data analyst%';


-- 4.1 Check how much the average data analyst salary is based on their experience
SELECT experience_level, (AVG(salary_in_usd) * 15000) / 12 AS avg_sal_rp_monthly
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
GROUP BY experience_level;

-- 4.2 Check how much the average data analyst salary is based on experience and type of employment?
SELECT
	experience_level,
    employment_type,
    (AVG(salary_in_usd) * 15000) / 12 AS avg_sal_rp_monthly
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
GROUP BY experience_level, employment_type
ORDER BY experience_level, employment_type;

-- 5. Check which countries have attractive salaries for data analysts,
-- with filters: Employment Type: Full time and Work Experience: Entry Level and Mid.
SELECT company_location, AVG(salary_in_usd) avg_sal_in_usd
FROM ds_salaries
WHERE
	job_title LIKE '%data analyst%'
	AND employment_type = 'FT'
	AND experience_level IN ('MI', 'EN')
GROUP BY company_location
HAVING avg_sal_in_usd >= 20000;

-- 6. In what year, the highest salary increase for full-time data analyst from mid to senior?
WITH ds_1 AS (
	SELECT work_year, AVG(salary_in_usd) sal_in_usd_ex
	FROM ds_salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'EX'
		AND job_title LIKE '%data analyst%'
	GROUP BY work_year
),
ds_2 AS (
	SELECT work_year, AVG(salary_in_usd) sal_in_usd_mi
	FROM ds_salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'MI'
		AND job_title LIKE '%data analyst%'
	GROUP BY work_year
),
t_year AS (
	SELECT DISTINCT work_year
	FROM ds_salaries
)
SELECT
	t_year.work_year,
	ds_1.sal_in_usd_ex,
	ds_2.sal_in_usd_mi,
	ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi differences
FROM
	t_year
	LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
	LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;