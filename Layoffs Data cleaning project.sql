SELECT *
FROM layoffs
CREATE TABLE layoffs_staging 
LIKE layoffs ;

SELECT * FROM layoffs_staging

INSERT layoffs_staging 
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

-- REMOVING DUPLICATES
-- CHECK FOR DUPS
WITH DUP_CTE AS
(
SELECT *,
row_number() Over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage ,country,funds_raised_millions ) AS ROW_NUM
from layoffs_staging
)
SELECT *
FROM DUP_CTE
WHERE ROW_NUM > 1;


SELECT *
FROM layoffs_staging
WHERE company = 'Casper'

WITH DUP_CTE AS
(
SELECT *,
row_number() Over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage ,country,funds_raised_millions ) AS ROW_NUM
from layoffs_staging
)
Delete *
FROM DUP_CTE
WHERE ROW_NUM > 1;

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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoffs_staging2
SELECT *,
row_number() Over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date',
stage ,country,funds_raised_millions ) AS ROW_NUM
from layoffs_staging;

with cte as 
(
select *,
row_number() over(
 partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoffs_staging2
)
select *
from cte
where row_num > 1;



select *
FROM layoffs_staging2
where row_num > 1;

-- standardizing data
select company, trim(company)
FROM layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct(industry)
FROM layoffs_staging2
order by 1;


select * 
FROM layoffs_staging2;

update  layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select *
FROM layoffs_staging2
where country like 'united states%';

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'united states%';

select distinct country
FROM layoffs_staging2
order by 1;

select *
FROM layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date (`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

select *
FROM layoffs_staging2
where industry is null
or industry ='';


select  industry
FROM layoffs_staging2
where company = 'Airbnb';

select t1.industry , t2.industry 
FROM layoffs_staging2  as t1
join layoffs_staging2  as t2
	on t1.company = t2.company
where (t1.industry is null )
and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry ='';

update layoffs_staging2 t1
join layoffs_staging2  as t2
	on t1.company = t2.company
set  t1.industry = t2.industry 
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

select *
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2 
drop column row_num; 


-- fixing duplicate problem 

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging3
SELECT *,
row_number() Over(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage ,country,funds_raised_millions ) AS ROW_NUM
from layoffs_staging2;

select *
from layoffs_staging3
where row_num > 1 ;