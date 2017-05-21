module App.ModelHttp exposing (..)

import App.Model exposing (..)
import Json.Decode exposing (..)
import JsonApi
import JsonApi.Http
import Http


recipeDecoderWithIdAndImage : String -> Maybe String -> Decoder Recipe
recipeDecoderWithIdAndImage id image =
    map8 Recipe
        (succeed id)
        (field "title" string)
        (field "field_difficulty" string)
        (field "field_ingredients" (list string))
        (field "field_total_time" int)
        (field "field_preparation_time" int)
        (field "field_recipe_instruction" (field "value" string))
        (succeed image)


getRecipes : Cmd Msg
getRecipes =
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


getRecipe : String -> Cmd Msg
getRecipe id =
    let
        request =
            JsonApi.Http.getPrimaryResource
                ("http://localhost:8890/node/recipe/"
                    ++ id
                    ++ "?include=field_image&fields[file--file]=uuid,url,uri&fields[node--recipe]="
                    ++ "title,"
                    ++ "field_difficulty,"
                    ++ "field_ingredients,"
                    ++ "field_total_time,"
                    ++ "field_preparation_time,"
                    ++ "field_recipe_instruction,"
                    ++ "field_image"
                )
    in
        Http.send RecipeLoaded request


fileDecoder : Decoder File
fileDecoder =
    map2 File
        (field "uuid" string)
        (field "url" string)
