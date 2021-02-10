--UFO Shape by city and state

select ufo.shape, 
	   ufo.city, 
	   state."Code"
from ufo
left join state
on ufo.state = lower(state."Code");

-- Number of ufo sightings per state
select count(datetime), state from ufo
group by state
order by count(datetime) desc;

-- Number of UFO sightings per 1 million people in the US

select count(ufo.datetime) / sum(covid19."Population") * 1000000 as avg_rate,
ufo.state
--covid19."State",
--lower(state."Code")
from ufo
left join state
on ufo.state = lower(state."Code")
left join covid19
on covid19."State" = state."State_Name"
where ufo.country = 'us'
group by ufo.state, covid19."State", state."State_Name", state."Code", covid19."Population"
order by avg_rate desc;

-- Avg ufo sightings per total covid deaths

select count(ufo.datetime) / sum(covid19."Deaths") as avg_rate,
ufo.state
--covid19."State",
--lower(state."Code")
from ufo
left join state
on ufo.state = lower(state."Code")
left join covid19
on covid19."State" = state."State_Name"
where ufo.country = 'us'
group by ufo.state, covid19."State", state."State_Name", state."Code", covid19."Population"
order by avg_rate desc;

-- Avg Number of Covid deaths by ufo shape

select distinct(ufo.shape), avg(covid19."Deaths")
from ufo
left join state
on ufo.state = lower(state."Code")
left join covid19
on state."State_Name" = covid19."State"
group by ufo.shape
;

-- Triangle UFO Sightings where the shape was a triangle and the comments contain a variation of silence or silent. 
--Brought in how many med-large airports from the covid data set

select ufo.shape, ufo.comments, state."State_Name", covid19."Med-Large_Airports"
from ufo
left join state
on ufo.state = lower(state."Code")
left join covid19
on covid19."State" = state."State_Name"
where ufo.shape = 'triangle' and ufo.comments like '%silen%'
order by state."State_Name"
;

-- Aggregate number of silent triangles by state with med-large airports from the covid dataset.

select count(ufo.shape) as silent_triangle_count, state."State_Name", covid19."Med-Large_Airports"
from ufo
left join state
on ufo.state = lower(state."Code")
left join covid19
on covid19."State" = state."State_Name"
where ufo.shape = 'triangle' and ufo.comments like '%silen%'
group by state."State_Name", covid19."Med-Large_Airports"
order by state."State_Name"
-- or order by silent_triangle_count desc
;
