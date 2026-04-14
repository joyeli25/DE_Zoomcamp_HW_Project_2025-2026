1. Temporal Analysis Matrix
----- Crime trends over time
SELECT crime_year,
crime_month,
primary_type,
count(crime_id) incident_count,
round(avg(case when arrest then 1 else 0 end) *100, 2) as arrest_rate,
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by crime_year,
crime_month,
primary_type
order by crime_year,
crime_month,
incident_count desc;

2. Geographic Hotspot Matrix
----- Spatial crime distribution
SELECT district,
ward,
community_area,
primary_type,
count(crime_id) as incident_count,
count(distinct block) as affected_block,
avg(latitude) as avg_lat,
avg(longitude) as avg_lng
FROM `chi-crime-project-491821.mart.fact_crimes` 
where latitude is not null and longitude is not null
group by district,
ward,
community_area,
primary_type
order by incident_count desc;

3. Crime Type Analysis Matrix
----- Crime type effectiveness matrix
SELECT 
primary_type,
description,
count(*) as total_incidents,
sum(case when arrest then 1 else 0 end) as arrests_made,
sum(case when domestic then 1 else 0 end) as domestic_incidents,
round(avg(case when arrest then 1 else 0 end) *100, 2) as arrest_rate,
round(avg(case when domestic then 1 else 0 end) *100, 2) as domestic_rate
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by primary_type,
description
order by total_incidents desc;

4. Time-Based Pattern Matrix
----- Hourly and daily patterns
SELECT 
primary_type,
extract(hour from PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S',crime_date)) as crime_hour,
crime_weekday,
count(*) as incident_count,
round(avg(case when arrest then 1 else 0 end) *100, 2) as arrest_rate
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by primary_type,
crime_hour,
crime_weekday
order by primary_type, incident_count desc;

5. Location Risk Assessment Matrix
----- Location-based risk analysis
SELECT 
location_description,
primary_type,
count(*) as incident_count,
round(avg(case when arrest then 1 else 0 end) *100, 2) as arrest_rate,
round(avg(case when domestic then 1 else 0 end) *100, 2) as domestic_rate
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by location_description,
primary_type
having count(*) >100  -- Only significant locations
order by incident_count desc;

6. FBI Code Severity Matrix
----- Crime severity analysis by FBI codes and IUCR Codes
SELECT 
iucr,
fbi_code,
primary_type,
description,
count(*) as incident_count,
round(avg(case when arrest then 1 else 0 end) *100, 2) as arrest_rate,
min(crime_date) as first_occurrence,
max(crime_date) as last_occurrence
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by iucr,
fbi_code,
primary_type,
description
order by incident_count desc

7. Beat and District Performance Matrix
----- Law enforcement effectiveness by area
SELECT 
district,
beat,
count(*) as incident_count,
sum(case when arrest then 1 else 0 end) as arrests_made,
count(distinct primary_type) as crime_variety,
round(avg(case when arrest then 1 else 0 end) *100, 2) as clearance_rate
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by district,
beat
order by clearance_rate desc, incident_count desc;

8. Community Area Vulnerability Matrix
----- Community area risk profiling
SELECT 
community_area,
count(*) as crime_count,
count(distinct primary_type) as crime_types,
round(avg(case when domestic then 1 else 0 end) *100, 2) as domestic_violence_rate,
round(avg(case when arrest then 1 else 0 end) *100, 2) as law_enforcement_rate
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by community_area
order by crime_count desc;

9. Seasonal Trend Analysis Matrix
----- Seasonal crime patterns
SELECT 
primary_type,
extract(quarter from PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S',crime_date)) as crime_quarter,
crime_month,
count(*) as incident_count,
round((count(*) *100 / sum(count(*))over(partition by primary_type)),2) as seasonal_percentage
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by primary_type,crime_quarter, crime_month
order by primary_type, crime_quarter, incident_count desc;

10. Comprehensive Dashboard Query
----- Executive summary dashboard
SELECT 
crime_year,
count(*) as incident_count,
count(distinct primary_type) as unique_crime_types,
sum(case when arrest then 1 else 0 end) as total_arrests,
sum(case when domestic then 1 else 0 end) as domestic_incidents,
round(avg(case when arrest then 1 else 0 end) *100, 2) as overall_clearance_rate,
count(distinct community_area) as affected_communities,
count(distinct beat) as active_beats
FROM `chi-crime-project-491821.mart.fact_crimes` 
group by crime_year
order by crime_year;