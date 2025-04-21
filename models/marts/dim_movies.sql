select 
    *
from {{ ref('stg_dim_movies') }}
