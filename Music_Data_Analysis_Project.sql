### MUSIC DATA ANALYSIS PROJECT 

Create database Music ;

use music ;
select * from album ;

# Question 1  Who is the senior most employee based on job title ?
select * from employee ;

1. select employee_id, first_name, last_name, title, levels, email from employee order by levels desc ;

2. select employee_id, first_name, last_name, title, levels, email from employee 
where levels = 7 ;

3. select employee_id, first_name, last_name, title, levels, email from employee 
order by levels desc 
offset 0 rows 
fetch next 1 row only ;

4. select Top 1  employee_id, first_name, last_name, title, levels, email from employee 
order by levels desc ;

# Question 2 which countries have the most invoices ?
select * from invoice ;

select billing_country, count(*) from invoice 
group by billing_country 
order by billing_country desc ;

# Question 3 what are top 3 values of total invoice ?

select Top 3 billing_country, round(total,2) as highest_invoices from invoice 
order by highest_invoices desc ;

#or 

select billing_country, round(total,2) as highest_invoices from invoice
order by highest_invoices desc
offset 0 row
fetch next 3 row only ;


#Question 4 which city has the best customers ? We would like to throw a promotional music festival in the city 
 we made the most money. write a query that returns one city that has the highest sum of invoice totals. 
 returns both the city name & sum of all invoices ??

 select * from invoice ;

 select billing_city, round(sum(total),2) as highest_invoice from invoice 
 group by billing_city 
 order by highest_invoice desc 
 offset 0 row
 fetch next 1 row only ;

 #Question 5 who is the best customer? the customer who has spent the most money will be declared 
 the best customer. write a query that returns the person who has spent the most money ?
 select * from customer  ;
 select * from invoice ;

 select top 1 cu.customer_id, cu.first_name, cu.last_name, round(sum(iv.total),2) as total_spent from customer cu inner join
 invoice iv on cu.customer_id = iv.customer_id 
 group by cu.customer_id, cu.first_name, cu.last_name
 order by total_spent desc ;
  
 #Question 6 Write query to return the email, first name, last name, & genre of all rock music listeners. Return 
 your list ordered alphabatically by email starting with A 
 select * from customer ;
 select * from genre ;

 select distinct email, first_name, last_name from customer ca inner join invoice iv on 
 ca.customer_id = iv.customer_id inner join invoice_Line il on iv.invoice_id = il.invoice_id 
 where track_id in
(select track_id from track tr inner join genre ge on tr.genre_id = ge.genre_id where ge.name like 'Rock')
order by email ;

or 

Select distinct
    c.email,
    c.first_name,
    c.last_name,
    g.name AS genre
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
JOIN invoice_line il 
    ON i.invoice_id = il.invoice_id
JOIN track t 
    ON il.track_id = t.track_id
JOIN genre g 
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;
 


 #Question 7 Lets  invite the artist who have written the most rock music in our dataset, write a query that returns 
 the artist name and total track count of the top 10 rock bands

 select * from artist;
 select * from album;
 select * from genre ;
 select * from track ;

 select top 10 ar.name,count(tr.name) as track_count from artist ar inner join album al
 on ar.artist_id = al.artist_id join track tr on al.album_id = tr.album_id inner join genre ge on 
 tr.genre_id = ge.genre_id 
 where ge.name = 'Rock' 
 group by ar.name 
 order by track_count desc ;


 #Question 8 Return all the track names that have been a song length longer than the average song length. return 
 the name and milliseonds for each track. Order by the song length with the longest songs listed first.
 
 select * from track ;
 
select name, milliseconds from track 
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc ;

 #Question 9 Find how much amount spent by each customer on astrist ? Write a query to return customer name artist 
 name and total spent ?
  select * from artist ;
  select * from customer ;
  select *  from invoice ;
  select *  from invoice_line ;

select cu.first_name, cu.last_name, ar.name, (SUM(il.unit_price * il.quantity)) as total_spent from customer cu inner join invoice iv on 
cu.customer_id = iv.customer_id inner join invoice_line il on iv.invoice_id = il.invoice_id inner join track tr on
il.track_id = tr.track_id inner join album al on tr.album_id = al.album_id inner join Artist ar on al.artist_id = 
ar.artist_id
group by cu.first_name, cu.last_name,ar.name
order by total_spent ;

 or

WITH customer_spending AS (
    SELECT 
        cu.customer_id,
        cu.first_name,
        cu.last_name,
        ar.name AS artist_name,
        (il.unit_price * il.quantity) AS amount
    FROM customer cu
    JOIN invoice iv ON cu.customer_id = iv.customer_id
    JOIN invoice_line il ON iv.invoice_id = il.invoice_id
    JOIN track tr ON il.track_id = tr.track_id
    JOIN album al ON tr.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
)

SELECT 
    first_name,
    last_name,
    artist_name,
    SUM(amount) AS total_spent
FROM customer_spending
GROUP BY first_name, last_name, artist_name
ORDER BY total_spent DESC;
