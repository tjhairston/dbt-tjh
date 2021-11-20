# Project Answers

## Week 1 

### Question 1: How many users do we have?
#### Answer: 130
#### Query: SELECT COUNT(user_id) FROM stq_users;

### Question 2: On average, how many orders do we receive per hour?
#### Answer: 16.2500000000000000
#### Query: 
            WITH orders_per_hour as (
                SELECT count(*) 
                FROM stg_orders 
                WHERE created_at_utc is not null 
                GROUP BY date_part ('hour' , created_at_utc)
            )
            SELECT AVG(count) FROM orders_per_hour

### Question 3: On average, how long does an order take from being placed to being delivered?
#### Answer: { "days": 3, "hours": 22, "minutes": 13, "seconds": 10, "milliseconds": 504.451 }
#### Query: 
            SELECT AVG(delivered_at_utc - created_at_utc)
            FROM stg_orders
            WHERE status = 'delivered' 
### Question 4: How many users have only made one purchase? Two purchases? Three+ purchases?
#### Answer: one purchase = 25 | two purchases = 22 | three or more purchases = 81
#### Query: 
            WITH order_count as (   
                SELECT COUNT(*) as num_purchases, user_guid 
                FROM stg_orders 
                GROUP BY user_guid
            )
            SELECT 
                COUNT(CASE WHEN num_purchases = 1 then 1 ELSE NULL END) as "one purchase",
			    COUNT(CASE WHEN num_purchases = 2 then 1 ELSE NULL END) as "two purchases",
			    COUNT(CASE WHEN num_purchases > 2 then 1 ELSE NULL END) as "three or more purchases"
            FROM order_count;

### Question 5: On average, how many unique sessions do we have per hour?
#### Answer: 123.1250000000000000
#### Query: 
            WITH hourly_sessions as (
                SELECT date_part('hour', created_at_utc) as session_hour
                    ,count(distinct session_guid) as session_unique 
                FROM stg_events where created_at_utc is not null 
                GROUP BY 1
                )
            SELECT AVG(session_unique) FROM hourly_sessions;