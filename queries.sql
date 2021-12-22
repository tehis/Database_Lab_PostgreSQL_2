-- 1
select  r.region_description , t.territory_description
from region r inner join territories t on r.region_id = t.region_id;

-- 2
select r.region_description, count(et.employee_id)
from region r inner join territories t on r.region_id = t.region_id 
inner join employee_territories et on t.territory_id = et.territory_id
group by r.region_id ;


-- 3
select od.order_id , od.unit_price * od.quantity * (1-od.discount )
from order_details od;

-- 4
select p.product_id, p.product_name, sum(od.quantity) as s
from products p inner join order_details od on p.product_id = od.product_id 
group by p.product_id 
order by s desc 
limit 10;

-- 5
select p.product_id, p.product_name 
from products p 
where p.product_id not in (select product_id from order_details od);

-- 6
select p.product_id, count(p.product_id)
from products p left join order_details od on p.product_id = od.product_id
group by p.product_id 
order by count(p.product_id) asc;



-- 7
with order_sell as (
select od.order_id, o.employee_id, o.order_date, od.unit_price * od.quantity * (1-od.discount ) as sell
from order_details od inner join orders o on o.order_id = od.order_id 
)
select e.employee_id, e.first_name, e.last_name, sum(oa.sell) as ss
from employees e inner join order_sell oa on e.employee_id = oa.employee_id
where extract (year from oa.order_date) = '1996'
group by e.employee_id 
order by ss desc 
limit 1;

-- 8
select o.order_id, 
	case when o.order_date = o.shipped_date  then 'Excelent'
		 when o.shipped_date - o.order_date < 3 then 'Good'
		 else 'Inappropriate'
	end
from orders o;


-- 10
select extract (year from a.shipped_date) as shipped_year,
sum(b.subtotal) 
from orders a
inner join 
(
	select distinct od.order_id, sum(od.unit_price * od.quantity) as subtotal
	from order_details od
	group by order_id 
) b on a.order_id = b.order_id
where a.shipped_date is not null 
group by shipped_year
order by shipped_year;

-- 11
create view should_buy as
select p.product_id, p.product_name, p.units_in_stock 
from products p 
where p.units_in_stock < p.reorder_level
order by p.units_in_stock;

select * from should_buy;

-- 12
with categories_sent_to_france as (
select distinct c.category_name
from categories c inner join products p on p.category_id = c.category_id 
inner join order_details od on od.product_id = p.product_id 
inner join orders o on o.order_id = od.order_id 
where o.ship_country = 'France'
)
select c2.category_name 
from categories c2 
where c2.category_name not in (
select * from categories_sent_to_france
);


-- 14
select *
from customers c 
where c.fax is null;


-- 15
create view find_age as 
select *, age(e.birth_date) as employee_age
from employees e


select r.region_description, avg(fa.employee_age)
from employee_territories et inner join public.find_age fa on fa.employee_id = et.employee_id 
inner join territories t on t.territory_id = et.territory_id 
inner join region r on t.region_id = r.region_id 
group by r.region_id 










