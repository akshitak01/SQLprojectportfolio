
SELECT *
FROM [Project Portfolio]..CoronavirusDeathsData
where continent is not NULL
Order by 3,4


--SELECT *
--FROM [Project Portfolio].dbo.CoronavirusVaccinationData
--Order by 3,4

-- Selecting data is going to be used

SELECT Location, date, total_cases, new_cases, total_deaths, population
From [Project Portfolio]..CoronavirusDeathsData
Order by 1,2

-- Looking at the total cases vs the total deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio]..CoronavirusDeathsData
Order by 1,2

-- Looking at the data of a particular country of interest

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio]..CoronavirusDeathsData
WHERE Location = 'India'
Order by 1,2

--Locking at the death percentage of United States

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Project Portfolio]..CoronavirusDeathsData
WHERE Location like '%states%'
Order by 1,2


-- Exploring data for Total cases vs the Population of a given country

SELECT Location, date, total_cases, total_deaths, Population, (total_cases/population)*100 as CovidcasesPerc
From [Project Portfolio]..CoronavirusDeathsData
WHERE Location like 'India'
Order by 1,2


-- Looking at the highest number of total cases vs the population of a country

SELECT Location, Max(total_cases) as HighestInfCount, Max(total_deaths) as MaximumDeaths, Max((total_cases/Population))*100 as PercentPopulationInfected, Max((total_deaths/Population))*100 as PercentPopulationDied
From [Project Portfolio]..CoronavirusDeathsData
--WHERE Location = 'India'
Group by Location, Population 
Order by PercentPopulationInfected, PercentPopulationDied desc



-- Looking at Glbal number 

Select Date, Location, SUM(cast(total_deaths as int)) as Total_DeathsbyLocation
From [Project Portfolio]..CoronavirusDeathsData
Where continent is not Null 
Group by Date, Location
Order by 1,2 

