{% macro grant_select(role_name) %}

    {% set sql %}
    grant usage on schema {{ schema }} to {{ role_name }};
    grant select on {{ this }} to {{ role_name }};
    {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}