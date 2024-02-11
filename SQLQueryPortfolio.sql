

use portfolio_10;

--whole  CovidDeath table
select * from CovidDeaths;

---Death percentage in India
select *,(total_cases/total_deaths)*100 as 
death_percentage from CovidDeaths 
where location like '%India%' order by 1,2;

--percentage of population got affected by covid in India
select location,date,population,total_cases,total_deaths,(total_deaths/population)*100 as 
affected_population from CovidDeaths 
where location like '%India%' and total_deaths is not null order by 1,2;

--location with highest infected rate in accordance with population
select location,population,max(total_cases) as highest_Infected_count,max((total_cases/population)*100) as 
affected_population from CovidDeaths where location not like '%income' and location not like 'world'
group by population,location
order by highest_Infected_count desc;

--countries with highest death vs population
select location,population,max(total_deaths) as Total_death 
from CovidDeaths  where location not like 'world' and location not like '%income' and continent is not null
group by location,population
order by Total_death desc;

--study locationwise seperate
select location, max(total_deaths) 
as Total_Death from CovidDeaths
where continent is null and location not like '%income'
group by location order by	Total_Death desc ;

--study continentwise seperate
select continent, max(total_deaths) 
as Total_Death from CovidDeaths
where continent is not null and location not like '%income'
group by continent order by	Total_Death desc ;


-- across the globe
select date,sum(new_cases) as total_case,sum(new_deaths) as total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null and new_cases<>0
group by date
order by 1,2;


--total global case and deaths and percentage
select sum(new_cases) as total_case,sum(new_deaths) as total_deaths,(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null and new_cases<>0
order by 1,2;

--WHOLE VACCINATION TABLE
select * from vaccinations;

--looking at Total population vs vaccination
select d.continent,d.location,d.date,d.population  from CovidDeaths d
Join vaccinations v
on d.location=v.location 
and d.date=v.date
where d.continent is not null
order by 2,3;

---Death percentage in India
select *,(total_cases/total_deaths)*100 as 
death_percentage from CovidDeaths 
where location like '%India%' order by 1,2;

--percentage of population got affected by covid in India
select location,date,population,total_cases,total_deaths,(total_deaths/population)*100 as 
affected_population from CovidDeaths 
where location like '%India%' and total_deaths is not null order by 1,2;

--location with highest infected rate in accordance with population
select location,population,max(total_cases) as highest_Infected_count,max((total_cases/population)*100) as 
affected_population from CovidDeaths where location not like '%income' and location not like 'world'
group by population,location
order by highest_Infected_count desc;

--countries with highest death vs population
select location,population,max(total_deaths) as Total_death 
from CovidDeaths  where location not like 'world' and location not like '%income' and continent is not null
group by location,population
order by Total_death desc;

--study locationwise seperate
select location, max(total_deaths) 
as Total_Death from CovidDeaths
where continent is null and location not like '%income'
group by location order by	Total_Death desc ;

--study continentwise seperate
select continent, max(total_deaths) 
as Total_Death from CovidDeaths
where continent is not null and location not like '%income'
group by continent order by	Total_Death desc ;


-- across the globe

select date,sum(new_cases) as total_case,sum(new_deaths) as total_deaths,(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
--total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null and new_cases<>0
group by date
order by 1,2;

--total global case and deaths and percentage

select sum(new_cases) as total_case,sum(new_deaths) as total_deaths,(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null and new_cases<>0
order by 1,2;

--Vaccination table
select * from vaccinations;

--looking at Total population vs vaccination
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(bigint,v.new_vaccinations)) over (partition by d.location order by d.location) as rolling_people_vaccinated from CovidDeaths d
Join vaccinations v
on d.location=v.location 
and d.date = v.date
where d.continent is not null and v.new_vaccinations is not null
order by 2,3;

--USE CTE
--With PopVsVac (continent,location,date,new_vaccinations,rolling_people_vaccinated)
--as
--(
--select d.continent,d.location,d.date,d.population,v.new_vaccinations,
--sum(convert(bigint,v.new_vaccinations)) over (partition by d.location,d.date)
--as rolling_people_vaccinated from
--portfolio_10..CovidDeaths d Join portfolio_10..vaccinations v on
--d.location = v.location and d.date = v.date
--where d.continent is not null 
--)


--Creating view to store data for visualization

CREATE VIEW PercentPopulationVaccinated as 
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(convert(bigint,v.new_vaccinations)) over (partition by d.location,d.date) 
as rolling_people_vaccinated
from portfolio_10..CovidDeaths d Join portfolio_10..vaccinations v  on
d.location = v.location and d.date = v.date
where d.continent is not null 
--order by 2,3

select top(100) [continent],
                [location],
				[date],
                [population],
				[new_vaccinations],
				[rolling_people_vaccinated] from 
				PercentPopulationVaccinated;

select * from PercentPopulationVaccinated;
