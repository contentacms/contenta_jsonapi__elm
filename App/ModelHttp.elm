module App.ModelHttp exposing (..)

import App.Model exposing (..)
import Json.Encode
import Json.Decode exposing (..)
import JsonApi.Resources
import JsonApi
import JsonApi.Http
import Http
import RemoteData


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


articleDecoderWithIdAndImage : String -> Maybe String -> Decoder Article
articleDecoderWithIdAndImage id image =
    map4 Article
        (succeed id)
        (field "title" string)
        (at [ "body", "value" ] string)
        (succeed image)


getRecipes : Flags -> Cmd Msg
getRecipes flags =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/node/recipe"
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file&fields[field_image]=field_image&fields[file--file]=url,uuid"
                    ++ "&fields[node--recipe]="
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


getArticles : Flags -> Cmd Msg
getArticles flags =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/node/article"
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file&fields[field_image]=field_image&fields[file--file]=url,uuid"
                    ++ "title,"
                    ++ "field_recipes,"
                    ++ "body"
                )
    in
        Http.send ArticlesLoaded request


getPromotedRecipes : Flags -> Cmd Msg
getPromotedRecipes flags =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/node/recipe"
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file&fields[field_image]=field_image&fields[file--file]=url,uuid"
                    ++ "&fields[node--recipe]="
                    ++ "title,"
                    ++ "field_difficulty,"
                    ++ "field_ingredients,"
                    ++ "field_total_time,"
                    ++ "field_preparation_time,"
                    ++ "field_recipe_instruction,"
                    ++ "field_image"
                    ++ "&filter[promote][value]=1"
                    ++ "&pager[limit]=3"
                )
    in
        RemoteData.sendRequest request
            |> Cmd.map PromotedRecipesLoaded


getPromotedArticles : Flags -> Cmd Msg
getPromotedArticles flags =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/node/article"
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file&fields[field_image]=field_image&fields[file--file]=url,uuid"
                    ++ "&fields[node--article]="
                    ++ "title,"
                    ++ "field_image,"
                    ++ "field_recipes,"
                    ++ "body,"
                    ++ "&filter[promote][value]=1"
                    ++ "&pager[limit]=3"
                )
    in
        RemoteData.sendRequest request
            |> Cmd.map PromotedArticlesLoaded


getRecipe : Flags -> String -> Cmd Msg
getRecipe flags id =
    let
        request =
            JsonApi.Http.getPrimaryResource
                (flags.apiBaseUrl
                    ++ "/node/recipe/"
                    ++ id
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file&fields[field_image]=field_image&fields[file--file]=url,uuid"
                    ++ "&fields[node--recipe]="
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


mediaDecoder : Decoder Media
mediaDecoder =
    map Media
        (field "uuid" string)


decodeRecipe : Flags -> JsonApi.Resource -> Maybe Recipe
decodeRecipe flags resource =
    let
        id =
            JsonApi.Resources.id resource

        file_image =
            JsonApi.Resources.relatedResource "field_image" resource
                |> Result.andThen (JsonApi.Resources.relatedResource "field_image")
                |> Result.andThen (JsonApi.Resources.attributes fileDecoder)
                |> Result.map (\file -> { file | url = flags.baseUrl ++ file.url })
                |> Result.toMaybe

        recipeResult =
            JsonApi.Resources.attributes (recipeDecoderWithIdAndImage id (Maybe.map .url file_image)) resource
                |> Result.toMaybe
    in
        recipeResult


decodeArticle : Flags -> JsonApi.Resource -> Maybe Article
decodeArticle flags resource =
    let
        id =
            JsonApi.Resources.id resource

        file_image =
            JsonApi.Resources.relatedResource "field_image" resource
                |> Result.andThen (JsonApi.Resources.relatedResource "field_image")
                |> Result.andThen (JsonApi.Resources.attributes fileDecoder)
                |> Result.map (\file -> { file | url = flags.baseUrl ++ file.url })
                |> Result.toMaybe

        articleResult =
            JsonApi.Resources.attributes (articleDecoderWithIdAndImage id (Maybe.map .url file_image)) resource
                |> Result.toMaybe
    in
        articleResult



--loginRequest : LoginDetails -> Cmd Msg
--loginRequest loginDetails =
--    let
--        request =
--            123
--    in
--        Http.send (Result Http.Error LoginCompleted)
--            (Http.post "http://localhost:8890/user/login?_format=json"
--                (encodeLoginData loginDetails)
--                decodeLoginResult
--            )
--
--
--encodeLoginData : LoginDetails -> Http.Body
--encodeLoginData details =
--    Http.jsonBody <|
--        Json.Encode.object
--            [ ("name" Json.Encode.string details.name)
--            , ("pass" Json.Encode.string details.password)
--            ]
--
--decodeLoginResult : Json.Decoder
