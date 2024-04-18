SELECT
    city_name

FROM
    {{ ref('dim_cities' )}}

WHERE
    city_name !~ '^[A-Z].*'
