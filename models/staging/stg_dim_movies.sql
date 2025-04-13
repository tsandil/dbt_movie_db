with popular_movies as (

    select
        movie_key,
        movie_id,
        genre_id,
        movie_title,
        english_title,
        movie_language,
        movie_description,
        popularity,
        vote_average,
        is_adult,
        is_video,
        release_date,
        source_system
    from {{ ref('stg_movie_db_popular_movies') }}

),

now_playing_movies as (

    select
        movie_key,
        movie_id,
        genre_id,
        movie_title,
        english_title,
        movie_language,
        movie_description,
        popularity,
        vote_average,
        is_adult,
        is_video,
        release_date,
        source_system
    from {{ ref('stg_movie_db_now_playing_movies') }}

),

top_rated_movies as (

    select
        movie_key,
        movie_id,
        genre_id,
        movie_title,
        english_title,
        movie_language,
        movie_description,
        popularity,
        vote_average,
        is_adult,
        is_video,
        release_date,
        source_system
    from {{ ref('stg_movie_db_top_rated_movies') }}

),

upcoming_movies as (

    select
        movie_key,
        movie_id,
        genre_id,
        movie_title,
        english_title,
        movie_language,
        movie_description,
        popularity,
        vote_average,
        is_adult,
        is_video,
        release_date,
        source_system
    from {{ ref('stg_movie_db_upcoming_movies') }}

),

combined_sources as (

    select * from popular_movies
    union 
    select * from now_playing_movies
    union 
    select * from top_rated_movies
    union 
    select * from upcoming_movies

),

pre_aggregated as (

    select
        movie_key,
        movie_id,
        genre_id,
        movie_title,
        english_title,
        movie_language,
        is_adult,
        is_video,
        release_date,
        source_system,
        max(movie_description) as movie_description,
        max(popularity) as popularity,
        max(vote_average) as vote_average
    from combined_sources
    group by 1,2,3,4,5,6,7,8,9,10

),

json_aggregated as (

    select
        movie_key,
        movie_id,
        movie_title,
        english_title,
        movie_language,
        movie_description,
        is_adult,
        is_video,
        release_date,
        jsonb_object_agg(source_system, genre_id) as genre_id,
        jsonb_object_agg(source_system, popularity) as popularity_by_source,
        jsonb_object_agg(source_system, vote_average) as vote_average_by_source
    from pre_aggregated
    group by 1,2,3,4,5,6,7,8,9

),

source_aggregated as (

    select
        movie_key,
        array_agg(source_system) as source_system
    from combined_sources
    group by movie_key

),

json_agg_source_agg as (

    select
        ja.movie_key,
        ja.movie_id,
        ja.genre_id,
        ja.movie_title,
        ja.english_title,
        ja.movie_description,
        ja.popularity_by_source,
        ja.vote_average_by_source,
        ja.is_adult,
        ja.is_video,
        ja.release_date,
        sa.source_system
    from json_aggregated as ja
    join source_aggregated as sa
        on ja.movie_key = sa.movie_key

),

final as (

    select
        movie_key,
        movie_id,
        genre_id,
        movie_title,
        english_title,
        movie_description,
        popularity_by_source,
        vote_average_by_source,
        is_adult,
        is_video,
        release_date,
        source_system
    from json_agg_source_agg

)

select * from final
