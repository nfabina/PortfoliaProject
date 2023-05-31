Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

Select *
From PortfolioProject..CovidDeaths
Where continent is null
order by 3,4

Select *
From PortfolioProject..CovidVaccinations
order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- To find the Data Type of Columns in a Table
USE PortfolioProject
SELECT 
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_NAME, 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'CovidDeaths' 


-- Looking at Total Cases vs Total Deaths
Select Location, date, total_cases, total_deaths, (cast(total_deaths as Float)/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location, date, total_cases, Population, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1, 2

-- Looking at Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)) *100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population
Select Location, MAX(cast (Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT
Select continent, MAX(cast (Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null and new_cases != 0
Group By date
order by 1,2

--Death Percentage across the world of people infected with Covid
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null and new_cases != 0
--Group By date
order by 1,2

-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated,
-- (RollingPeopleVaccinated/population)*100 (Reason for Error: You cannot use a column you created to do additional arithmetic operations, either use CTE or Temp Table)
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3
