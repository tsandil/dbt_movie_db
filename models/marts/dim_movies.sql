with combined_sources as (

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
        release_date
    from {{ ref('stg_movie_db_popular_movies') }}

    union

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
        release_date
    from {{ ref('stg_movie_db_now_playing_movies') }}

    union

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
        release_date
    from {{ ref('stg_movie_db_top_rated_movies') }}

    union
    
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
        release_date
    from {{ ref('stg_movie_db_upcoming_movies') }}

)

select * from combined_sources