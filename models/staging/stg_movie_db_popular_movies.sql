with base_popular_movies as (

    select  
        movie_id,
        genre_id,
        movie_title,
        english_title,
        movie_language,
        movie_description,
        popularity,
        round(vote_average::numeric,1) as vote_average,
        is_adult,
        is_video,
        release_date,
        source_system
    from {{ ref('base_movie_db_popular_movies') }}

),

generate_keys as (

    select
        {{ dbt_utils.generate_surrogate_key(['movie_id']) }} as movie_key,
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
    from base_popular_movies

),

seed as (

    select
        {{ dbt_utils.generate_surrogate_key(['null']) }} as movie_key,
        00000 as movie_id,
        'Unknown' as genre_id,
        'Unknown' as movie_title,
        'Unknown' as english_title,
        'Unknown' as movie_language,
        'Unknown' as movie_description,
        00.00 as popularity,
        00.00 as vote_average,
        cast(null as boolean) as is_adult,
        cast(null as boolean) as is_video,
        '1999-12-31' as release_date,
        'Unknown' as source_system
    
    union 

    select
        {{ dbt_utils.generate_surrogate_key(['\'No Match\'']) }} as movie_key,
        000000 as movie_id,
        'No Match' as genre_id,
        'No Match' as movie_title,
        'No Match' as english_title,
        'No Match' as movie_language,
        'No Match' as movie_description,
        00.0000 as popularity,
        00.0000 as vote_average,
        cast(null as boolean) as is_adult,
        cast(null as boolean) as is_video,
        '1999-12-31' as release_date,
        'No Match' as source_system

),

unioned as (

    select  * from generate_keys
    union
    select * from seed

)

select * from unioned
