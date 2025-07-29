
select *
from layoffs;
-- remove dupilcate
-- standrdize the data
-- null VALUES
CREATE TABLE layoffs_staging
LIKE layoffs;

 SELECT * 
 FROM layoffs_staging;
 
 INSERT layoffs_staging
 SELECT *
 FROM layoffs;
 
  SELECT * ,
  ROW_NUMBER() OVER ( PARTITION BY
  company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
 FROM layoffs_staging;
 
 with duplicate_cte AS
 (
   SELECT * ,
  ROW_NUMBER() OVER ( PARTITION BY
  company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
 FROM layoffs_staging
 )
 SELECT *
 FROM duplicate_cte
 WHERE row_num>1;
 
 select *
 FROM layoffs_staging
 where company = 'casper';
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO layoffs_staging2
 SELECT * ,
  ROW_NUMBER() OVER ( PARTITION BY
  company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
 FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
;
-- STANDARDIZATION DATA
SELECT company, trim(COMPANY)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT company
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'CRYPTO%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'CRYPTO%';



DELETE
FROM layoffs_staging2
where row_num > 1;

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT country, trim(trailing '.' FROM country) country
FROM layoffs_staging2
ORDER BY 1;

SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
on t1.company = t2.company
WHERE (t1.industry IS NULL OR  t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
on t1.company = t2.company
SET T1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t2
SET industry = NULL
WHERE industry ='';

SELECT *
FROM layoffs_staging2
where company = 'AIRBNB';

SELECT *
FROM layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
drop COLUMN row_num;

