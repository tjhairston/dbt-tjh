# Project Answers
# PART 1

## Week 2

### Question 1: What is our user repeat rate? ()
### Note: Repeat Rate = Users who purchased 2 or more times / users who purchased
        * Answer: 79.838%
            * Query: SELECT (repeat_buyers * 1.0 / total_buyers) * 100 
                        FROM (SELECT 
                                SUM(CASE WHEN count_orders >0 THEN 1 ELSE 0 END) as total_buyers, 
                                SUM(CASE WHEN count_orders >=2 THEN 1 ELSE 0 END) as repeat_buyers 
                            FROM user_order_fact) buyers;    

### Question 2: What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? 
    * A good indicator of who will likely purchase again: 
        - customer’s experience could affect repeat purchase example:customer receiving their item before the estimated delivery date as well as there being a short time to deliver (both items in the facts_order table).
        - Positive event / session items are also good indicators: repeat site visits aka high site engagement (page views, low amount of items deleted from cart, if a user has an account. 
        - Tenure of a customer and number of sessions 
   
    * All these items are apart of the fact_page_views table. 
        - A good indicator of who will likely NOT purchase again: 
    	- A low number of items in cart / being purchased, no account by user, poor delivery of items (items taking longer than expected / estimated). 
        - In addition, poor session / event engagement by users: low site visits, etc. 

    * If you had more data, what features would you want to look into to answer this question?
        - With more data, I would be interested in more site data and comparing how long users are staying on what pages as well as diving into how to use promos to attract users. 

### Question 3
    Explain the marts models you added. Why did you organize the models in the way you did?
        - I created a marts layer segmented by typical business units: core datasets being flexible for use through the business. Marketing mdoels which are aimed at the marketing unit and product models aimed at the product unit. The marts/core models included: three main models. A dimension model for products (dim_products), and a dimension model for users (dim_users). These models were used to capture typical dimensions that would be asked about users and items that were ordered. Lastly a fact_ user_order which captured some information about users while aggregating order information. 
        - The above models served as the foundation to later build out the marketing and event tables. I then created a facts_user_order which really was aimed at summarizing order and user data to gain insights. This detailed orders at the user level, with some calculations such as avg and sums on statuses and order totals.  
        - Lastly, I created a dim_events and a fact_page_view to which page information was captured along with event data and aggerated session information and event information by user. A key part of this section was to summarize page status information. 
### Use the dbt docs to visualize your model DAGs to ensure the model layers make sense
    - Paste in an image of your DAG from the docs
	!(<img width="1154" alt="dag_tj" src="https://user-images.githubusercontent.com/81575873/143792734-2bd196e9-3859-4582-9bed-985b105aab85.png">)


# PART 2 - Tests

### Question 4
    What assumptions are you making about each model? (i.e. why are you adding each test?)
        - The main assumptions I made were: 
        - that the _guids were always unique and not null. 
	    - Accepted values, based on order statuses
        - Lastly ensuring specific calculation and specific fields were not null and positive values. 
    Furthermore - I would like to set up more test to validate the order data to ensure there are no issues around order calculations. 
    
    Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
        - I believe with better tests I would discover more issues within the data. There were no failures of my always_unique or not null, but I would bet that there could be some issues with agg tables. Thus, I would like to revisit to test the data more strictly. I would then filter out some of those one offs assuming there are issues with agg table items. 
        - In addition, to perform daily tests, I would recommend to schedule the dbt run follwoed by test daily on snapshots.    
