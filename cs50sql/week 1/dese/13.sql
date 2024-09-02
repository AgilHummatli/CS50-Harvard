SELECT schools.city, AVG(graduated) AS avg_graduation
FROM schools
JOIN graduation_rates ON schools.id = graduation_rates.school_id
GROUP BY schools.city
ORDER BY avg_graduation DESC
LIMIT 10;
