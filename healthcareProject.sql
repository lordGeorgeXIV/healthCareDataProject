/*
Objetivos 
Realiza una tabla de contenido de las vacunas antigripales en 2022 con lo siguiente

1.) Total % de pacientes que han recibido la vacuna antigripal desglosado por

	a.) Edad
	b.) Razas
	c.) Condado (Sobre un mapa)
	d.) En general

2.) Ejecuta el total de vacunas sobre el curso del año 2022
3.) Total de vacunas dadas en el año 2022
4.) Lista de pacientes que muestre si han recibido o no la vacuna

Requerimientos:
Los pacientes deben estar activos en nuestro hospital (no tener mas de dos años sin presentase en el hospital)
El paciente debe tener 6 meses o mas años de edad
El paciente debe estar vivo
*/ 


with active_patients as
(
select distinct patient
from encounters as e
join patients as pat
	on e.patient = pat.id
where start between '2020-01-01 00:00:00' and '2022-12-31 00:00'
and pat.deathdate is null
and extract(month from age('2022-12-31', pat.birthdate)) >= 6
),

flu_shot_2022 as
(
select patient, min(date) as earliest_flu_shot_2022
from immunizations 
where code = '5302'
and date between '2022-01-01 00:00:00' and '2022-12-31 23:59'
group by patient
)
-- Obteniendo el overall 
select
	pat.birthdate,
	extract(year from age('2022-12-31', pat.birthdate)) as age,
	pat.race,
	pat.county,
	pat.id,
	pat.first,
	pat.last,
	flu.earliest_flu_shot_2022,
	flu.patient,
	case when flu.patient is not null then 1
		 else 0
		 end as flu_shot_2022
from patients as pat
left join flu_shot_2022 as flu
	on pat.id = flu.patient
where 1=1
and pat.id in(select patient from active_patients)
order by age


--where description like '%Flu%'
