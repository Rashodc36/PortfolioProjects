--Practise code
SELECT *
FROM #PercentPopulationVaccinated4
CREATE TABLE #temp_table(
EmployeeID int,
Jobtitle varchar(100),
salary int
)

Select *
FROM #temp_table

INSERT INTO #temp_table VALUES(
'1001', 'HR', '45000'
)
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--FROM PortfolioProject..CovidVaccinations
--Order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..dbo.CovidDeaths1
Order by 1,2

-- Looking at total cases vs total deaths
-- Shows the likelihoof of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
Order by 1,2

--Looking at the Total Cases vs Population
--Shows what percentage of population for covid

Select Location, date, total_cases,population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%state%'

--Looking at countries with highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestinfectionCount, Max((total_cases/population))*100 as PercentPolutionInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
Order by PercentPolutionInfected desc

--LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Showing Continent with Highest Death Count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Showing the countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc

--Global Numbers

Select date, SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location is like '%states%'
where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location is like '%states%'
where continent is not null
--Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
 order by 2,3

 --USE CTE
 
 With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
 as
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated8
Create Table #PercentPopulationVaccinated8
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated8
Select dea.continent, dea.Location, dea.Date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as Bigint)) OVER (partition by dea.Location Order by dea.Location,
	dea.Date) as RollingPeopleVaccinated
--, (RiollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null and vac.new_vaccinations is not null and dea.population is not null and dea.date is not null
--order by 2,3


Select *, (RollingPeopleVaccinated/Population)*100 as percent_pop
From #PercentPopulationVaccinated8

--Creating View to store later for Visualizations

Create View PercentPopulationVaccinated9 as
Select dea.continent, dea.Location, dea.Date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as Bigint)) OVER (partition by dea.Location Order by dea.Location,
	dea.Date) as RollingPeopleVaccinated
--, (RiollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null and vac.new_vaccinations is not null and dea.population is not null and dea.date is not null
--order by 2,3

Select *
From PercentPopulationVaccinated1

--Practice
Insert Into #PercentPopulationVaccinated6
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
 and dea.date = vac.date
	
Select *
FROM #PercentPopulationVaccinated6