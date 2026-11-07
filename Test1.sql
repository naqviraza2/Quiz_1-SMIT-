use bikestores;

---===========Quiz q1=======================

Select 
c.first_name,
c.last_name,
c.city
From sales.customers as c
Where c.city IN ('NY' ,'CA') AND c.email LIKE '%.com' AND c.last_name like 'M%'
ORDER BY c.city ASC, c.last_name  DESC;

---===========Quiz q2=======================

SELECT
    product_name,
    list_price,
    list_price * 0.90 AS discounted_price
FROM production.products
WHERE list_price > 500
ORDER BY list_price DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;


---===========Quiz q3=======================


SELECT
order_id, 
order_date
FROM sales.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-06-30'
AND order_id = 1 or order_id =2 or order_id =3

---===========Quiz q4=======================
    
SELECT
    o.order_id,
    o.order_date,
    s.store_name,
    p.product_name,
    c.first_name + ' ' + c.last_name as full_name

FROM sales.orders AS o

INNER JOIN sales.customers AS c
    ON c.customer_id = o.customer_id

INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id

INNER JOIN production.stocks AS st
    ON o.store_id = st.store_id

INNER JOIN production.products AS p
    ON p.product_id = st.product_id

where order_status = 4
ORDER BY o.order_date DESC

---===========Quiz q5=======================

Select
p.product_name,
c.category_name,
b.brand_name,
o.order_id
From production.categories as c
left join production.products as p
on c.category_id = p.category_id

left join production.brands as b
on b.brand_id = p.brand_id

left join sales.order_items as oi
on p.product_id = oi.product_id

left join sales.orders o
on o.order_id = oi.order_id

where o.order_id is null

---==== q6=======
SELECT
    e.first_name + ' ' + e.last_name AS employee,
    m.first_name + ' ' + m.last_name AS manager,
    s.store_name
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id

left join sales.stores as s
ON e.store_id = s.store_id

---==== q10=======

SELECT first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
    WHERE order_id IN (
        SELECT order_id
        FROM sales.order_items
        WHERE product_id IN (
            SELECT product_id
            FROM production.products
            WHERE brand_id IN (
                SELECT brand_id
                FROM production.brands
                WHERE brand_name = 'Electra'))));


--=======Q11=========
SELECT first_name, last_name
FROM sales.customers
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders
    WHERE sales.orders.customer_id = sales.customers.customer_id);

--===q8========
SELECT
p.category_id,
    c.category_name,
    b.brand_name,
    Count (*) as prod_count,
    Sum (p.list_price) as sum_price,
    Avg (p.list_price) as avg_price
FROM production.products as p
INNER JOIN production.categories AS c
    ON c.category_id = p.category_id

INNER JOIN production.brands AS b
    ON b.brand_id = p.brand_id

group BY c.category_name,p.category_id, b.brand_name
having p.category_id in (1,3);


------=====q9===========

SELECT
    s.store_name,
    YEAR(o.order_date) AS order_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores s
JOIN sales.orders o
    ON s.store_id = o.store_id
JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    s.store_name,
    YEAR(o.order_date)
ORDER BY
    s.store_name,
    order_year;
