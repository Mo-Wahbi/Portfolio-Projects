-- Exploratory Data Analysis

select *
From layoffs_staging2;


select max(total_laid_off) , max(percentage_laid_off)
From layoffs_staging2;

select *
From layoffs_staging3
where percentage_laid_off =1
order by 9  desc;

select company, sum(total_laid_off) 
From layoffs_staging3
group by company 
order by 2 desc;

select min(`date`) , max(`date`)
From layoffs_staging3;

select country, sum(total_laid_off) 
From layoffs_staging3
group by country
order by 2 desc;

select *
From layoffs_staging3;

select stage, sum(total_laid_off) 
From layoffs_staging3
group by stage
order by 2 desc;

select substring(`date`,1,7) as `month` , sum(total_laid_off) 
From layoffs_staging3
where `date` is not null
group by `month`
order by 1 asc;


with rolling_total as 
(
select substring(`date`,1,7) as `month` , sum(total_laid_off) as total_off
From layoffs_staging3
where `date` is not null
group by `month`
order by 1 asc
)
select `month`,total_off,sum(total_off) 
over(order by `month`) as ROL_TatOL
from rolling_total
;


select company, sum(total_laid_off) 
From layoffs_staging3
group by company 
order by 2 desc;
-- top 5 ranking company total laid offs through the years
with company_year (company,years,total_laid_off) as 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging3
group by company ,year(`date`)
), company_year_ranking as
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year 
where years is not NULL
)
select * 
from company_year_ranking 
where ranking <= 5
order by years;