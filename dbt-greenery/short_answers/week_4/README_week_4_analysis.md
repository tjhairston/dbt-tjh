### 1. Modeling challenge

## Let’s say that the Director of Product at greenery comes to us (the head Analytics Engineer) and asks some questions:

### How are our users moving through the product funnel? 
### Product Funnel Rate: 
    | Total Sessions    | Sessions with Product page View|  Session with Add-to-Cart | Session with Transaction |
    |-------------------|--------------------------------|---------------------------|--------------------------|
    |       100%        |           48%                  |              43%          |             36%          |
    |       1108        |           528                  |              480          |             400          |
### Query: 
            SELECT  
            ROUND((page_viewed_count / unquie_session_count::DECIMAL),2) * 100 as page_view_rate, 
            ROUND((add_to_cart_count / unquie_session_count::DECIMAL),2) * 100 as add_to_cart_rate, 
            ROUND((checkout_count / unquie_session_count::DECIMAL),2) * 100 as checkout_rate
            FROM {{ ref('product_funnel_rates_agg') }} 
### Analysis:  
            Items are moving though the funnel as dencent rates - high % of conversions, more digging can be done to uncover what items are the cause of high conversions vs low conversions. Would love to dive more in on consumer behaviour.           
### Which steps in the funnel have largest drop off points? 
    * Sessions with any event of type page_view / add_to_cart / checkout - Level 1
    * Sessions with any event of type add_to_cart / checkout - Level 2
    * Sessions with any event of type checkout - Level 3
### Query: 
            WITH session_bool as(
            SELECT 
                session_guid,
                COUNT(CASE WHEN event_type='page_view' THEN 1 END) AS pv,
                COUNT(CASE WHEN event_type='add_to_cart' THEN 1 END) AS atc,
                COUNT(CASE WHEN event_type='checkout' THEN 1 END) AS co
            FROM {{ref ('dim_events')}} 
            GROUP BY session_guid
            )

            SELECT 
                COUNT(CASE WHEN (pv >0 or atc >0 or co >0) THEN 1 END) AS level_1,
                COUNT(CASE WHEN (atc > 0 or co > 0) THEN 1 END) AS level_2,
                COUNT(CASE WHEN (co > 0) THEN 1 END) AS level_3
            FROM session_bool
### Answer: 
    | level_1           | level_2       | level_3 |
    |-------------------|---------------|----------------|
    |       696         |     609      |    400     |
### Analysis: 
    * Users are moving through the funnel decently as mentioend, but there seems to be a high drop off off folks who visit the site and actaully view product pages. 