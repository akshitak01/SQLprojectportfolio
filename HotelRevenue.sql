-- Data Exploration --

Select *
From dbo.['2018']

Select *
From dbo.['2019']

Select *
From dbo.['2020']

Select *
From dbo.['2018']
union
Select *
From dbo.['2019']
union
Select *
From dbo.['2020'];

With CTE_Hotels as
(
Select *
From dbo.['2018']
union
Select *
From dbo.['2019']
union
Select *
From dbo.['2020'] 
)

--Select * 
--From CTE_Hotels

-- Check to see if Hotel revenue growing by year --

--Select arrival_date_year, hotel, round(sum((stays_in_weekend_nights+stays_in_week_nights) * adr),2) as revenue
--From CTE_Hotels
--Group by arrival_date_year, hotel

Select * 
From CTE_Hotels
Left Join market_segment
on CTE_Hotels.market_segment = market_segment.market_segment
left join meal_cost
on meal_cost.meal = CTE_Hotels.meal