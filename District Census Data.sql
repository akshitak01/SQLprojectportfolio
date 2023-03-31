Select *
From Data1

Select *
From Data2

-- number of rows present in the dataset --

Select count(*)
From Data1

Select count(*)
From Data2

-- Generate data for only 2 states --
Select *
From Data1
Where State in ('Jharkhand', 'Bihar')
Order by State

-- Total Population of India --

Select Sum(Population) as Total_Population
From Data2


-- Average Population growth --

Select Avg(Growth) * 100 as Average_Growth_Percentage
From Data1

-- Average growth % by state --

Select State, Avg(Growth) * 100 as Average
From Data1
Group by State

-- Average Sex ratio --

Select State, round(Avg(Sex_Ratio),0) as Avg_Sexratio
From Data1
Group by State
Order by Avg_Sexratio desc

-- Average literacy rate -- 
Select State, round(Avg(Literacy),0) as Avg_Literacy
From Data1
Group by State
Having round(Avg(Literacy),0) > 90
Order by Avg_Literacy desc

-- Top states showing highest growth ratio --
Select Top 3 State, Avg(Growth) * 100 as Average
From Data1
Group by State
Order by Average desc

-- Top 3 states showing lowest sex ratio --

Select top 3 State, round(Avg(Sex_Ratio),0) as Avg_sexratio
From Data1
Group by State
Order by Avg_sexratio

-- Top and Bottom 3 states in Literacy using Temp Table --

IF Object_ID ('tempdb..#TopStates_Literacy') IS NOT NULL   --  To drop a Temp table Object_ID is used -- 

Drop Table #TopStates_Literacy


Create Table #TopStates_Literacy
(
	State nvarchar(255),
	topstates float
);

Insert INTO #TopStates_Literacy 
	Select state, round(avg(literacy),0) as Avg_Literacy 
From Data1 
Group by State
Order by Avg_Literacy DESC

Select top 3 * 
From #TopStates_Literacy 
Order by #TopStates_Literacy.topstates desc  -- Point to note, once the temp table query executed, don't run it again. Instead just execute the next query based on Temp Table-- 


IF Object_ID ('tempdb..#BottomStates_Literacy') IS NOT NULL   --  To drop a Temp table Object_ID is used -- 

Drop Table #BottomStates_Literacy

Create Table #BottomStates_Literacy
(
	State nvarchar(255),
	bottomstates float
);

Insert into #BottomStates_Literacy
Select state, round(avg(literacy),0) as Avg_Literacy 
From Data1
Group by State
Order by Avg_Literacy 

Select top 3 * 
From #BottomStates_Literacy 
Order by #BottomStates_Literacy.bottomstates

-- Using Union to combine two tables --

Select * From (
Select top 3 * 
From #TopStates_Literacy 
Order by #TopStates_Literacy.topstates desc) A

Union

Select * From (
Select top 3 * 
From #BottomStates_Literacy 
Order by #BottomStates_Literacy.bottomstates ) B

-- Filtering out States starting with letter A --

Select Distinct State 
From Data1
Where Lower(State) like 'a%' or lower(state) like 'b%'

-- Filtering out States starting with letter A but end with D--

Select Distinct State 
From Data1
Where Lower(State) like 'a%' and lower(state) like '%h'


-- Joining tables --

Select data1.District, data1.State, sex_ratio, population
From Data1
Inner Join Data2
  on Data1.District = Data2.District 

/*  female/male = sex_ratio, females + males = population, females = population - males, 

(population - males) = (sex_ratio) * males

Population = males (sex_ratio + 1) therefore males = population / (sex_ratio + 1) ... males

females = population - ((population)/(sex_ratio + 1)) ..... females */ 

-- Calculating total males and total females --

Select Total.state, sum(Total.males) as Total_Males , sum(Total.females) as Total_Females
From
(
	Select Popdata.district, Popdata.state, round(Popdata.population/(Popdata.sex_ratio + 1),0) as males , round((Popdata.population * Popdata.sex_ratio)/(Popdata.sex_ratio + 1),0) as females 
		From
			 ( 
				Select data1.District, data1.State, data1.Sex_Ratio/1000 sex_ratio, data2.Population
				From Data1
				Inner Join Data2
					on Data1.District = Data2.District 

			)  as Popdata
) as Total
Group by Total.State


-- Total Literacy rates --

/* Total Literate people/population = Literacy_ratio 
therefore Total literate people = literacy_ratio * population 

Total illiterate people = (1 - literacy_ratio)* poplulation */

Select Numofliteracy.state, sum(Numofliteracy.literate_people) as Number_of_literate_people, sum(Numofliteracy.illiterate_people) as Number_of_illiterate_people
From
(
	Select Literacy.district, Literacy.state, round(Literacy.literacy_ratio*population ,0) as literate_people, round((1-Literacy.literacy_ratio)*population ,0) as illiterate_people 
	From 
		(
			Select data1.District, data1.State, data1.Literacy/100 as literacy_ratio, data2.Population
					From Data1
					Inner Join Data2
						on Data1.District = Data2.District 
		) as Literacy
) as Numofliteracy
Group by Numofliteracy.State


 -- Population for previous Census --

 /* previous_census + growth*previous_census = population 
 previous_census = population/(1+growth) */
  

Select Sum(Tot.PreviousCensus_Pop) as Total_Pop_Previous_Census, Sum(Tot.CurrentCensus_Pop) as Total_Pop_Current_Census
From
	(
		Select av.state, sum(av.previous_census_pop) as PreviousCensus_Pop, sum(av.current_census_pop) as CurrentCensus_Pop
		From
		 (
			Select Grw.District, Grw.state, round(Grw.population/(1+Grw.Growth),0) as Previous_Census_Pop, Grw.Population as Current_Census_Pop
			From
			  (
				Select data1.District, data1.State, data1.Growth as Growth, data2.Population
							From Data1
							Inner Join Data2
								on Data1.District = Data2.District 
			  ) as Grw
		 ) as av
		 Group by State
	) as Tot
	 

-- Population based on Area in km^2 -- 

Select H.total_area/h.Total_Pop_Previous_Census as PrevPopvsArea, H.total_area/h.Total_Pop_Current_Census as CurPopvsArea
From 
	(
		Select TableC.*,TableD.total_area
		From
			(
			Select '1' as SrNo, TableA.*  -- adding a common field between two datasets which don't have anything in commmon--
			From
				(

					Select Sum(Tot.PreviousCensus_Pop) as Total_Pop_Previous_Census, Sum(Tot.CurrentCensus_Pop) as Total_Pop_Current_Census
					From
						(
							Select av.state, sum(av.previous_census_pop) as PreviousCensus_Pop, sum(av.current_census_pop) as CurrentCensus_Pop
							From
							 (
								Select Grw.District, Grw.state, round(Grw.population/(1+Grw.Growth),0) as Previous_Census_Pop, Grw.Population as Current_Census_Pop
								From
								  (
									Select data1.District, data1.State, data1.Growth as Growth, data2.Population
												From Data1
												Inner Join Data2
													on Data1.District = Data2.District 
								  ) as Grw
							 ) as av
							 Group by State
						) as Tot
				) as TableA
			) as TableC

		Inner Join 

		(
			Select '1' as SrNo, TableB.*
			From 
				(
					Select sum(area_km2) as total_area 
					From Data2
				) as TableB
		) TableD on TableC.SrNo = TableD.SrNo
	) as H
