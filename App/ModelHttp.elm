module App.ModelHttp exposing (..)

import App.Model exposing (..)
import Json.Decode exposing (..)
import JsonApi
import JsonApi.Http
import Http

recipeDecoder : Decoder Recipe
recipeDecoder =
    map2 Recipe
        (field "title" string)
        (field "field_total_time" int)


getRecipe : Cmd Msg
getRecipe =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection "http://localhost:8890/node/recipe"
    in
        Http.send RecipeLoaded request


