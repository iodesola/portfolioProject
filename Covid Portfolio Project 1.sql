select * from PortfolioPorject..CovidDeaths
select *from PortfolioPorject..CovidVaccinations

select location,date, population, total_cases, new_cases, new_deaths, total_deaths from PortfolioPorject..CovidDeaths where location like '%states%'
order by 2,3

select population, total_cases, (total_cases/population)*100 as InfectionRate from PortfolioPorject..CovidDeaths
where location like '%states%' 
order by InfectionRate DESC

select Location, Population,MAX(total_cases) as HighestInfected, MAX((total_cases/population))*100 as HighestInfectionRate from PortfolioPorject..CovidDeaths
Group by location, population
order by HighestInfectionRate DESC

select location,date, population, total_cases from PortfolioPorject..CovidDeaths where location like '%marino%'
order by total_cases desc

---Showinf countries with highest Death--
select Location, MAX(cast(total_deaths as int)) as HighestDeath from PortfolioPorject..CovidDeaths
where continent is not null
Group by location
order by HighestDeath DESC

---Showing continent with highest Death--
select continent, MAX(cast(total_deaths as int)) as HighestDeath from PortfolioPorject..CovidDeaths
where continent is not null
Group by continent
order by HighestDeath DESC

--shwoing location with highest death where continent is null
select Location, MAX(cast(total_deaths as int)) as HighestDeath from PortfolioPorject..CovidDeaths
where continent is null
Group by location
order by HighestDeath DESC
--Global Death Rate
select date,SUM(new_cases) as Total_new_cases, SUM(cast(new_deaths as int)) as Total_new_death, ISNULL(SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases),0),0)*100 as GlobalDeathRate
from PortfolioPorject..CovidDeaths
where continent is not null
Group by date
order by GlobalDeathRate desc

select SUM(new_cases) as Total_new_cases, SUM(cast(new_deaths as int)) as Total_new_death, ISNULL(SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases),0),0)*100 as GlobalDeathRate
from PortfolioPorject..CovidDeaths
where continent is not null
--Group by date
order by 1,2

--Joining the two tables together on location and date, then extract location, continent, date, population and vaccinatinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	from PortfolioPorject..CovidDeaths dea
	join PortfolioPorject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
order by 2, 3

--Get rolling count of the new_Vacination by location--
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
	OVER (Partition by dea.location Order by dea.date, dea.location) as RollingNewVaccinated
		from PortfolioPorject..CovidDeaths dea
			join PortfolioPorject..CovidVaccinations vac
		on dea.location=vac.location
			and dea.date=vac.date
		where dea.continent is not null
order by 2, 3
---Storing Generated Data and rollingNew Vaccination in PopVsVac.. this is an attempt to you CTE as to be able %vaccinated versus Population
with PopVsVac (Continent,Location,Date, Population, New_vacinations, RollingNewVacinate) as (
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
	OVER (Partition by dea.location Order by dea.date, dea.location) as RollingNewVaccinated

		from PortfolioPorject..CovidDeaths dea
			join PortfolioPorject..CovidVaccinations vac
		on dea.location=vac.location
			and dea.date=vac.date
		where dea.continent is not null

)

Select *,(RollingNewVacinate/Population) * 100 as RateVaccinated from PopVsVac

--Creating temp. Table and Inserting to achieve same as above
Drop Table if exists #PopVaccinated
Create Table #PopVaccinated (
	Continent nvarchar(255),
	Location nvarchar(255),
	Date Datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingNVaccinated numeric,

)

insert into #PopVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
	OVER (Partition by dea.location Order by dea.date, dea.location) as RollingNewVaccinated

		from PortfolioPorject..CovidDeaths dea
			join PortfolioPorject..CovidVaccinations vac
		on dea.location=vac.location
			and dea.date=vac.date
		where dea.continent is not null

Select *,(RollingNVaccinated/Population) * 100 as RateVaccinated from #PopVaccinated

--Create View to Store Generated values for Visualization

Create View PercentPopVacc as 
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
		OVER (Partition by dea.location Order by dea.date, dea.location) as RollingNewVaccinated

			from PortfolioPorject..CovidDeaths dea
				join PortfolioPorject..CovidVaccinations vac
			on dea.location=vac.location
				and dea.date=vac.date
			where dea.continent is not null
Select * from PercentPopVacc