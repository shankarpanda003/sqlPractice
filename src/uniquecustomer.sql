CREATE temp TABLE customer_visits (
    visit_date DATE,
    customer_id INT
);

INSERT INTO customer_visits (visit_date, customer_id) VALUES
('2024-06-01', 1),
('2024-06-01', 2),
('2024-06-02', 1),
('2024-06-02', 3),
('2024-06-03', 2),
('2024-06-03', 4),
('2024-06-04', 1),
('2024-06-04', 5);

with abc as (
select customer_id,min(visit_date) as min_visit_date from customer_visits
group by 1)
select a.visit_date,count(distinct a.customer_id) as unique_count
 from customer_visits a inner join abc b on a.customer_id=b.customer_id
and a.visit_date=b.min_visit_date
group by 1
