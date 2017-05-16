module App.ModelHttp exposing (..)

import App.Model exposing (..)
import Json.Decode exposing (..)
import JsonApi
import JsonApi.Http
import Http


recipeDecoder : Decoder Recipe
recipeDecoder =
    map6 Recipe
        (field "title" string)
        (field "field_difficulty" string)
        (field "field_ingredients" (list string))
        (field "field_total_time" int)
        (field "field_preparation_time" int)
        (field "field_recipe_instruction" (field "value" string))


getRecipe : Cmd Msg
getRecipe =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                ("http://localhost:8890/node/recipe?include=field_image&fields[file--file]=url,uri&fields[node--recipe]="
                    ++ "title,"
                    ++ "field_difficulty,"
                    ++ "field_ingredients,"
                    ++ "field_total_time,"
                    ++ "field_preparation_time,"
                    ++ "field_recipe_instruction,"
                    ++ "field_image"
                )
    in
        Http.send RecipesLoaded request
