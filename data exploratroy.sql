-- exploratory data
use world_layoffs;
select *
FROM layoffs_staging2;

SELECT MAX(total_laid_off)
From layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM( total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MAX(`DATE`), MIN(`DATE`)
FROM layoffs_staging2;

SELECT country, SUM( total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 desc;

SELECT YEAR(`DATE`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY YEAR(`DATE`)
ORDER BY 1 desc;

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

SELECT substring(`date`, 1,7) as `month` , sum(total_laid_off)
FROM layoffs_staging2
where substring(`date`, 1,7)  IS NOT NULL
GROUP BY `month`
ORDER BY 1 ;

SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates,TOTAL_LAID_OFF, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

SELECT  company, year(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company,  year(`date`)
ORDER BY 3 desc;

WITH company_year( company, years, total_laid_off) as(	
SELECT  company, year(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company,  year(`date`)),
company_year_rank as(
SELECT *, DENSE_RANK() over( PARTITION BY YEARS ORDER BY total_laid_off DESC) RANKING
FROM company_year
WHERE years IS NOT NULL AND total_laid_off IS NOT NULL
ORDER BY RANKING)
SELECT *
FROM company_year_rank;

