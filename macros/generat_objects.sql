{% macro get_objects() %}
    {% if target.name == 'dev' %}
        {% do log(target.database, info=True) %}
        {% do log(target.schema, info=True) %}
        {% do log(target.table, info=True) %}
    {% endif %}
{% endmacro %}


{% macro object_name(your_table_name) %}

    {% do log("Table Name " ~your_table_name, info=True) %}

{% endmacro %}
