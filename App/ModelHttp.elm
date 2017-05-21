module App.ModelHttp exposing (..)

import App.Model exposing (..)
import Json.Decode exposing (..)
import JsonApi
import JsonApi.Http
import Http


recipeDecoder : Decoder Recipe
recipeDecoder =
    recipeDecoderWithImage Nothing


recipeDecoderWithImage : Maybe String -> Decoder Recipe
recipeDecoderWithImage image =
    map7 Recipe
        (field "title" string)
        (field "field_difficulty" string)
        (field "field_ingredients" (list string))
        (field "field_total_time" int)
        (field "field_preparation_time" int)
        (field "field_recipe_instruction" (field "value" string))
        (succeed image)


getRecipe : Cmd Msg
getRecipe =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                ("http://localhost:8890/node/recipe?include=field_image&fields[file--file]=uuid,url,uri&fields[node--recipe]="
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


fileDecoder : Decoder File
fileDecoder =
    map2 File
        (field "uuid" string)
        (field "url" string)
