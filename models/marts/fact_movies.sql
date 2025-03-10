with combined_facts as (

    select
        movie_id,
        vote_count
    from {{ ref('base_movie_db_popular_movies') }}

    union all

    select
        movie_id,
        vote_count
    from {{ ref('base_movie_db_now_playing_movies') }}

    union all

    select
        movie_id,
        vote_count
    from {{ ref('base_movie_db_top_rated_movies') }}

    union all

    select
        movie_id,
        vote_count
    from {{ ref('base_movie_db_upcoming_movies') }}

),

dim_movies as (

    select
        movie_id,
        movie_key
    from {{ ref('dim_movies') }}

),

surrogate_keys as (

    select
        case
            when combined_facts.movie_id is null then {{ dbt_utils.generate_surrogate_key(['null']) }}
            when dim_movies.movie_id is null then {{ dbt_utils.generate_surrogate_key(['\'No Match\'']) }}
            else dim_movies.movie_key
        end as movie_key,
        combined_facts.vote_count
    from combined_facts
    left join dim_movies
        on combined_facts.movie_id = dim_movies.movie_id

),

final as (

    select
        movie_key,
        vote_count
    from surrogate_keys

)

select * from final