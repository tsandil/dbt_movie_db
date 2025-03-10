 with source as (

    select 
        *
    from {{ source('popular_movie_db', 'popular_movies') }}

),

renamed as (
    
    select
        -- ids/keys
        id as movie_id,
        genre_ids as genre_id,
        -- dimensions
        original_title as movie_title,
        original_language as movie_language,
        overview as movie_description,
        popularity,
        title as english_title,
        vote_average,
        adult as is_adult,
        video as is_video,
        -- fact/measures
        vote_count,
        -- date/time
        release_date,
        record_loaded_at,
        -- metadata
        backdrop_path,
        poster_path
    from source

),

final as (

    select
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
        vote_count,
        release_date,
        record_loaded_at,
        backdrop_path,
        poster_path,
        'popular movies' as source_system
    from renamed

)

select * from final
