-- Explore Covid Data on Deaths and Vaccinations among countries
Select * from CovidDataExploration..CovidDeaths
order by location
Select * from CovidDataExploration..CovidVaccination
order by location


-- 1. Overview: The big picture throughout the World
-- The world's current total cases, deaths, percentage infection rate, death rate over infected cases, vaccination

Select dea.location, dea.date, dea.population, dea.total_cases, dea.total_deaths, (dea.total_cases/dea.population)*100 as InfectionRate
, (dea.total_deaths/dea.total_cases)*100 as DeathRate, vac.total_vaccinations, (vac.total_vaccinations/dea.population) as VaccinationRate
from CovidDataExploration..CovidDeaths dea
join CovidDataExploration..CovidVaccination vac
on dea.location = vac.location and dea.date = vac.date
where dea.location='World' and vac.total_vaccinations = (select max(total_vaccinations) from CovidDataExploration..CovidVaccination
																						where location='World')


-- 2. Covid Cases and Death data continent
Select location, date, population, total_cases, total_deaths, (total_cases/population)*100 as InfectionRate, (total_deaths/total_cases)*100 as DeathRate
from CovidDataExploration..CovidDeaths
where continent is null 
	and date = (select max(date) from CovidDataExploration..CovidDeaths)
	and location not in (select location 
							from CovidDataExploration..CovidDeaths
							where location = 'World' or location = 'European Union' or location = 'International')


-- 3. Covid Cases, Death, Vaccination Rate by country
-- Highest records
Select dea.location, max(dea.population) as Population, max(dea.total_cases) as TotalCases, max(dea.total_deaths) as TotalDeaths
, (max(dea.total_cases)/max(dea.population))*100 as InfectionRate, (max(dea.total_deaths)/max(dea.total_cases))*100 as DeathRate
, max(vac.total_vaccinations) as TotalVaccinations, (max(vac.total_vaccinations)/max(dea.population))*100 as VaccinationRate
from CovidDataExploration..CovidDeaths dea
join CovidDataExploration..CovidVaccination vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
group by dea.location
order by 1
-- Data by Date
Select dea.location, dea.date, dea.new_cases, dea.total_cases, dea.total_deaths, vac.people_vaccinated
, (dea.total_cases/dea.population)*100 as InfectionRate, (vac.people_vaccinated/dea.population)*100 as VaccinationRate
from CovidDataExploration..CovidDeaths dea
join CovidDataExploration..CovidVaccination vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 1

-- Vietnam Covid Data
-- 4. Vietnam covid cases/deaths by date
Select location, date, population, new_cases, total_cases, total_deaths
, (total_deaths/total_cases) as DeathRate
from CovidDataExploration..CovidDeaths
where location = 'Vietnam'
order by 2


-- 5. Vietnam total number of people vaccinated, vaccination rate by date
Select dea.location, dea.date, dea.population, vac.people_vaccinated, vac.people_fully_vaccinated
, (vac.people_vaccinated/dea.population) as VaccinationRate, (vac.people_fully_vaccinated/dea.population) as FullyVaccinationRate
from CovidDataExploration..CovidDeaths dea
join CovidDataExploration..CovidVaccination vac
on dea.location = vac.location and dea.date = vac.date
where dea.location = 'Vietnam'
order by 2
