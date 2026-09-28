--IBM HR Attrition Project

create table hr_attrition(
Age int,
Attrition text,
BusinessTravel text,
DailyRate int,
Department text,
DistanceFromHome int,
Education int,
EducationField text,
EmployeeCount int,
EmployeeNumber int,
EnvironmentSatisfaction	int,
Gender text,
HourlyRate int,
JobInvolvement int,
JobLevel int,
JobRole text,
JobSatisfaction int,
MaritalStatus text,
MonthlyIncome int,
MonthlyRate int,
NumCompaniesWorked int,
Over18 text,
OverTime text,
PercentSalaryHike int,
PerformanceRating int,
RelationshipSatisfaction int,
StandardHours int,
StockOptionLevel int,
TotalWorkingYears int,
TrainingTimesLastYear int,
WorkLifeBalance int,
YearsAtCompany int,
YearsInCurrentRole int,
YearsSinceLastPromotion int,
YearsWithCurrManager int
);

copy hr_attrition(Age,Attrition,BusinessTravel,DailyRate,Department,DistanceFromHome,Education,EducationField,EmployeeCount,EmployeeNumber,EnvironmentSatisfaction,Gender,HourlyRate,JobInvolvement,JobLevel,JobRole,JobSatisfaction,MaritalStatus,MonthlyIncome,MonthlyRate,NumCompaniesWorked,Over18,OverTime,PercentSalaryHike,PerformanceRating,RelationshipSatisfaction,StandardHours,StockOptionLevel,TotalWorkingYears,TrainingTimesLastYear,WorkLifeBalance,YearsAtCompany,YearsInCurrentRole,YearsSinceLastPromotion,YearsWithCurrManager
) from 'C:\WA_Fn-UseC_-HR-Employee-Attrition.csv' delimiter ',' header;

select * from hr_attrition;

-- Overall attrition rate

select count(*) as total_employees,
sum(case when attrition = 'Yes' then 1 else 0 end) as left_company,
round(100.0 * sum(case when attrition = 'Yes' then 1 else 0 end) / count(*),2) as attrition_rate from hr_attrition;

-- Q1.Attrition rate by department
select Department,
 count(*) as total,
 sum(case when Attrition = 'Yes' then 1 else 0 end) as left_count,
 round(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end) / count(*),2) as attrition_pct from hr_attrition group by Department order by attrition_pct desc;


-- Q2.Does salary affect attrition?
select 
 case
  when MonthlyIncome < 3000 then 'Low (under 3k)'
  when MonthlyIncome between 3000 and 6000 then 'Mid (3k-6k)'
  when MonthlyIncome between 6000 and 12000 then 'Upper Mid (6k-12k)'
  else 'High (12k+)'
  end as salary_band,
count(*) as employees,
round(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end) / count(*),2) as attrition_pct 
 from hr_attrition
 group by salary_band
 order by attrition_pct desc;


-- Q3.Overtime and attrition - biggest factor?
select OverTime,
 count(*) as employees,
 sum(case when Attrition = 'Yes' then 1 else 0 end) as left_count,
 round(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end) / count(*),2) as attrition_pct 
   from hr_attrition
   group by OverTime;


--Q4.Job satisfaction vs attrition
select JobSatisfaction,
 case JobSatisfaction
  when 1 then 'Low'
  when 2 then 'Medium'
  when 3 then 'High'
  when 4 then 'Very High'
   end as satisfaction_label,
 count(*) as employees,
 round(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end) / count(*), 2) as attrition_pct
 from hr_attrition 
 group by JobSatisfaction
 order by JobSatisfaction;


--Q5.Work-life balance impact
select WorkLifeBalance,
 case WorklifeBalance
  when 1 then 'Bad'
  when 2 then 'Good'
  when 3 then 'Better'
  when 4 then 'Best'
   end as wlb_label,
  count(*) as employees,
  round(100.0 * sum(case when Attrition = 'Yes' then 1 else 02 end) / count(*), 2) as attrition_pct
  from hr_attrition
 group by WorkLifeBalance
 order by WorkLifeBalance;


--Q6.Age group analysis
select
 case
  when Age < 25 then 'Under 25'
  when Age between 25 and 35 then '25-35'
  when Age between 35 and 45 then '35-45'
   else 'Over 45'
end as age_group,
count(*) as employees,
  round(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end) / count(*), 2) as attrition_pct,
  round(avg(MonthlyIncome),0) as avg_salary
 from hr_attrition
 group by age_group
 order by attrition_pct desc;


--Q7.Years since promotion - do stuck employees leave?
select
 case
  when YearsSinceLastPromotion = 0 then 'Just Promoted'
  when YearsSinceLastPromotion between 1 and 2 then '1-2 years'
  when YearsSinceLastPromotion between 3 and 5 then '3-5 years'
   else 'Over 5 years'
 end as promotion_gap,
 count(*) as employees,
 round(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end) / count(*), 2) as attrition_pct
from hr_attrition
group by promotion_gap
order by attrition_pct desc;

--Q8.Profile of employees most likely to leave
select 
Department,
JobRole,
OverTime,
round(avg(MonthlyIncome),0) as avg_salary,
round(avg(yearsSinceLastPromotion),1) as avg_years_since_promo,
count(*) as employees,
round(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end) / count(*), 2) as attrition_pct
from hr_attrition
group by Department,JobRole,OverTime
having count(*) >=10
order by attrition_pct desc 
limit 15;
