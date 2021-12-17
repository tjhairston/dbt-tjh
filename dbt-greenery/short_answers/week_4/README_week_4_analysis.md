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
    * Users are moving through the funnel decently as mentioend, but there seems to be a high drop off off folks who visit the site and actaully view product pages. The convertions between when a user views a product page to adding the item to thier cart is doing very well. There could be some funnel improvment around getting users to view a product. 

### Reflection questions 
    * If your organization is thinking about using dbt, how would you pitch the value of dbt/analytics engineering to a decision maker at your organization? 
    - I would pitch the power of DBT via the power of having raw data avalible in the warehouse which puts power in transformtions; allowing for quick and easiy transformation for analysis. This can lead to a heap of downstream advantages. Without DBT it is hard for analyst to share work, and have visibility into what other analysts were working on. By using dbt and following best practices, we can eliminate a lot of these issues. dbt gives more power to analysts and Analytics Engineers. DBT enables analysts to work more like software engineers by following principles such as version control, code modularity, and collaboration. 
    * if you are thinking about moving to analytics engineering, what skills have you picked that give you the most confidence in pursuing this next step? Leveraging SQL and git to effectively work and collaborate on a data team. I have also brushed up on my ability to model data in a way to optimize for modularity and a single source of truth. Lastly, I am building up my skills to eventually have the ability to visualize data in ways that make it more easily understandable and make time to insight faster

    - 
    * Setting up for production / scheduled dbt run of your project And finally, before you fly free into the dbt night, we will take a step back and reflect: after learning about the various options for dbt deployment and seeing your final dbt project, how would you go about setting up a production/scheduled dbt run of your project in an ideal state? You don’t have to actually set anything up - just jot down what you would do and why. 
        * Hints: what steps would you have? Which orchestration tool(s) would you be interested in using? What schedule would you run your project on? Which metadata would you be interested in using? How/why would you use the specific metadata? , etc.
    - I would tryu to leverage the entire modern data stack - using an ingestion tool (Fivetran, stitch) a modern datawarehouse (snowflake, big query, redshift) - DBT and a BI tool (looker). I would want to leverage some DAG tool also, airflow or dagster for to orchestrate my dbt deployment, even though this process will most likely be owned by thea data engineering team. I would leverage hooks and try to automate the process as much as possible. 