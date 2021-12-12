{% macro grant_select(role_name) %}

    {% set sql %}
    grant usage on schema {{ schema }} to {{ reporting }};
    grant select on {{ this }} to {{ reporting }};
    {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}