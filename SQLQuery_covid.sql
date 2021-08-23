-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..covid_deaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, Population, total_cases, total_deaths
, (Try_convert(float, total_deaths))/(try_convert(float, total_cases))*100 as DeathPercentage
From PortfolioProject..covid_deaths
Where location like '%portugal%'

Select Location, date, Population, total_cases
, (Try_convert(float, total_cases))/(try_convert(float, population))*100 as PercentPopulationInfected
From PortfolioProject..covid_deaths
Where location like '%portugal%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max(try_convert(float, total_cases))/(try_convert(float, population))*100 as PercentPopulationInfected
From PortfolioProject..covid_deaths
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(try_convert(float, Total_deaths)) as TotalDeathCount
From PortfolioProject..covid_deaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

Select continent, MAX(try_convert(float, Total_deaths)) as TotalDeathCount
From PortfolioProject..covid_deaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(try_convert(float,new_cases)) as total_cases, SUM(try_convert(float, new_deaths)) as total_deaths, SUM(try_convert(float, new_deaths))/SUM(try_convert(float,New_Cases))*100 as DeathPercentage
From PortfolioProject..covid_deaths
where continent is not null 

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(try_convert(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
, (try_convert(float,vac.people_vaccinated)) / (try_convert(float,population))*100  as Percentage_People_Vaccinated
From PortfolioProject..covid_deaths dea
Join PortfolioProject..covid_vacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

--Using CTE

With PopvsVac (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(try_convert(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From PortfolioProject..covid_deaths dea
Join PortfolioProject..covid_vacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (PeopleVaccinated/population)*100  as Percentage_People_Vaccinated
From PopvsVac
order by 2,3

--Temp table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(try_convert(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From PortfolioProject..covid_deaths dea
Join PortfolioProject..covid_vacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
Select *, (PeopleVaccinated/population)*100  as Percentage_People_Vaccinated
From #PercentPopulationVaccinated
order by 2,3

-- Creating view to store data  for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(try_convert(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
, (try_convert(float,vac.people_vaccinated)) / (try_convert(float,population))*100  as Percentage_People_Vaccinated
From PortfolioProject..covid_deaths dea
Join PortfolioProject..covid_vacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
