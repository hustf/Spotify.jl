## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-album

"""
    album_get_single(album_id; market="")

    **Summary**: Get Spotify catalog information for a single album.

    # Arguments
    - `album_id` : The Spotify ID for the album.

    # Optional keywords
    - `market` : An ISO 3166-1 alpha-2 country code.

    # Example
```julia-repl
    julia> album_get_single("5XgEM5g3xWEwL4Zr6UjoLo")[1]
    JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 19 entries:
    :album_type             => "album"
    :artists                => JSON3.Object[{…
    :available_markets      => ["AD", "AE", "AG", "AL", "AM", "AO", "AR", "AT", "AU", "AZ"  …  "UZ", "VC", "VE", "VN", "VU", "WS", "XK", "ZA", "ZM", "ZW"]
    :copyrights             => JSON3.Object[{…
    :external_ids           => {…
    :external_urls          => {…
    :genres                 => Union{}[]
    :href                   => "https://api.spotify.com/v1/albums/5XgEM5g3xWEwL4Zr6UjoLo"
    :id                     => "5XgEM5g3xWEwL4Zr6UjoLo"
    :images                 => JSON3.Object[{…
    :label                  => "Universal Music Classics"
    :name                   => "Gladiator: 20th Anniversary Edition"
    :popularity             => 57
    :release_date           => "2020-05-09"
    :release_date_precision => "day"
    :total_tracks           => 35
    :tracks                 => {…
    :type                   => "album"
    :uri                    => "spotify:album:5XgEM5g3xWEwL4Zr6UjoLo"
```
"""
function album_get_single(album_id; market="")
    u1 = "albums/"
    u2 = urlstring(album_id)
    u3 = urlstring(;market)
    url = delimit(u1, u2, u3)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks

"""
    album_get_tracks(album_id; limit=20, offset=0, market="US")

**Summary**: Get Spotify catalog information about an album's tracks. Optional parameters
            can be used to limit the number of tracks returned.

# Arguments
- `album_id` : The Spotify ID for the album

# Optional keywords
- `limit`         : The maximum number of tracks to return. Default is set to 20.
- `offset` : The index of the first track to return. Default is 0.
- `market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> album_get_tracks("5XgEM5g3xWEwL4Zr6UjoLo")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
:href     => "https://api.spotify.com/v1/albums/5XgEM5g3xWEwL4Zr6UjoLo/tracks?offset=0&limit=20&market=US"
:items    => JSON3.Object[{…
:limit    => 20
:next     => "https://api.spotify.com/v1/albums/5XgEM5g3xWEwL4Zr6UjoLo/tracks?offset=20&limit=20&market=US"
```
"""
function album_get_tracks(album_id; limit=20, offset=0, market="")
    #return spotify_request("albums/$album_id/tracks?limit=$limit&offset=$offset&market=$market")
    u1 = "albums/$album_id/tracks"
    u2 = urlstring(; limit, offset, market)
    url = delimit(u1, u2)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-multiple-albums

"""
    album_get_multiple(album_ids; market="")

**Summary**: Get Spotify catalog information for multiple albums identified by their Spotify IDs.

# Arguments
- `album_ids` : A comma-separated list of the Spotify IDs for the albums. Maximum: 20 IDs.

# Optional keywords
- `market` : An ISO 3166-1 alpha-2 country code. Default is set to "US".

# Example
```julia-repl
julia> album_get_multiple("5XgEM5g3xWEwL4Zr6UjoLo, 2rpT0freJsmUmmPluVWqg5")[1]
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 1 entry:
:albums => JSON3.Object[{…
```
More formally,
```julia-repl
julia> album_get_multiple([SpId("5XgEM5g3xWEwL4Zr6UjoLo"), SpId("2rpT0freJsmUmmPluVWqg5")])[1]
```

"""
function album_get_multiple(album_ids; market="")
    u1 = "albums?ids="
    u2 = urlstring(album_ids)
    u3 = urlstring(;market)
    url = delimit(u1, u2, u3)
    spotify_request(url)
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-albums

"""
    album_get_saved(;limit=20, market="", offset::Int64=0)

**Summary**: Get a list of the albums saved in the current Spotify user's 'Your Music' library.

# Optional keywords
- `limit`         : Maximum number of items to return, default is set to 20
- `market::String` : An ISO 3166-1 alpha-2 country code. If a country code is specified,
                    only episodes that are available in that market will be returned.
                    Default is set to "US".
- `offset::Int64` : Index of the first item to return, default is set to 0

# Example
```julia-repl
julia> album_get_saved()[1]

JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 7 entries:
  :href     => "https://api.spotify.com/v1/me/albums?offset=0&limit=20"
  :items    => JSON3.Object[{…
  :limit    => 20
  :next     => "https://api.spotify.com/v1/me/albums?offset=20&limit=20"
  :offset   => 0
  :previous => nothing
  :total    => 33
```
"""
function album_get_saved(;limit=20, market::String="", offset=0)
    u1 = "me/albums"
    u2 = urlstring(;limit, market, offset) #"me/albums?limit=$limit&market=$market&offset=$offset"
    url = delimit(u1, u2)
    spotify_request(url; scope = "user-library-read")
end


## https://developer.spotify.com/documentation/web-api/reference/#/operations/check-users-saved-albums

"""
    album_get_contains(album_ids)

**Summary**: Check if one or more albums is already saved in the current Spotify user's 'Your Music' library.

# Arguments
- `ids` : A comma-separated list of the Spotify album IDs

# Example
```julia-repl
julia> album_get_contains("382ObEPsp2rxGrnsizN5TX,1A2GTWGtFfWp7KSQTwWOyo")[1]

2-element JSON3.Array{Bool, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
0
0
```
"""
function album_get_contains(album_ids)
    return spotify_request("me/albums/contains?ids=$album_ids"; scope = "user-library-read")
end