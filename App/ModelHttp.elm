module App.ModelHttp exposing (..)

import App.Model exposing (..)
import Json.Encode
import Json.Decode exposing (..)
import JsonApi.Resources
import JsonApi
import JsonApi.Http
import Http
import RemoteData
import Result.Extra
import Json.Decode.Extra
import Result exposing (Result(..))
import Dict


type alias ImageResult =
    Result String String


recipeDecoderWithValues : String -> ImageResult -> List Term -> Decoder Recipe
recipeDecoderWithValues id image tags =
    map8 Recipe
        (succeed id)
        (field "title" string)
        (field "difficulty" string)
        (field "ingredients" (list string))
        (field "totalTime" int)
        (field "preparationTime" int)
        (field "instructions" string)
        (succeed <| Result.toMaybe image)
        |> Json.Decode.Extra.andMap (succeed tags)


articleDecoderWithIdAndImage : String -> ImageResult -> Decoder Article
articleDecoderWithIdAndImage id image =
    map4 Article
        (succeed id)
        (field "title" string)
        (at [ "body", "value" ] string)
        (succeed <| Result.toMaybe image)


getArticles : Flags -> Cmd Msg
getArticles flags =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/articles"
                    ++ "?"
                    ++ "include=image,image.field_image,image.field_image.files,tags"
                    ++ "&fields[image]=image&fields[file--file]=url,uuid"
                    ++ "title,"
                    ++ "recipes,"
                    ++ "body,"
                    ++ "tags,"
                )
    in
        RemoteData.sendRequest request
            |> Cmd.map ArticlesLoaded


getRecipePerCategory : Flags -> String -> Cmd Msg
getRecipePerCategory flags category =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/recipes"
                    ++ "?"
                    ++ "include=image,image.field_image,tags"
                    --                    ++ "&fields[image]=image&fields[file--file]=url,uuid,tags"
                    --                    ++ "&fields[recipes]="
                    --                    ++ "title,"
                    --                    ++ "difficulty,"
                    --                    ++ "ingredients,"
                    --                    ++ "totalTime,"
                    --                    ++ "preparationTime,"
                    --                    ++ "instructions,"
                    --                    ++ "image,"
                    --                    ++ "tags,"
                    --                    ++ "&fields[tags]=tid,name"
                    ++
                        "&page[offset]=0"
                    ++ "&page[limit]=4"
                    ++ "&filter[category.name][value]="
                    ++ category
                )
    in
        RemoteData.sendRequest request
            |> Cmd.map (RecipesPerCategoryLoaded category)


getPromotedRecipes : Flags -> Cmd Msg
getPromotedRecipes flags =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/recipes"
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file,tags"
                    ++ "&fields[image]=image&fields[file--file]=url,uuid"
                    ++ "&fields[recipes]="
                    ++ "title,"
                    ++ "difficulty,"
                    ++ "ingredients,"
                    ++ "totalTime,"
                    ++ "preparationTime,"
                    ++ "instructions,"
                    ++ "image,"
                    ++ "tags,"
                    ++ "&fields[tags]=tid,name"
                    ++ "&filter[promote][value]=1"
                    ++ "&page[limit]=3"
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
                    ++ "/articles"
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file,tags"
                    ++ "&fields[image]=field_image&fields[file--file]=url,uuid"
                    ++ "&fields[node--article]="
                    ++ "title,"
                    ++ "image,"
                    ++ "tags,"
                    ++ "recipes,"
                    ++ "body,"
                    ++ "&fields[tags]=tid,name"
                    ++ "&filter[promote][value]=1"
                    ++ "&page[limit]=3"
                )
    in
        RemoteData.sendRequest request
            |> Cmd.map PromotedArticlesLoaded


getHomepageRecipes : Flags -> Cmd Msg
getHomepageRecipes flags =
    let
        request =
            JsonApi.Http.getPrimaryResourceCollection
                (flags.apiBaseUrl
                    ++ "/recipes"
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file,tags"
                    ++ "&fields[image]=image&fields[file--file]=url,uuid"
                    ++ "&fields[recipes]="
                    ++ "title,"
                    ++ "difficulty,"
                    ++ "ingredients,"
                    ++ "totalTime,"
                    ++ "preparationTime,"
                    ++ "instructions,"
                    ++ "image,"
                    ++ "tags,"
                    ++ "&fields[tags]=tid,name"
                    ++ "&filter[promote][value]=1"
                    ++ "&page[offset]=3"
                    ++ "&page[limit]=4"
                )
    in
        RemoteData.sendRequest request
            |> Cmd.map HomepageRecipesLoaded


getRecipe : Flags -> String -> Cmd Msg
getRecipe flags id =
    let
        request =
            JsonApi.Http.getPrimaryResource
                (flags.apiBaseUrl
                    ++ "/recipes/"
                    ++ id
                    ++ "?"
                    ++ "include=field_image,field_image.field_image,field_image.field_image.file--file,tags,field_image.owner,field_image.field_image.owner"
                    ++ "&fields[image]=image&fields[file--file]=url,uuid"
                    ++ "&fields[recipes]="
                    ++ "title,"
                    ++ "difficulty,"
                    ++ "ingredients,"
                    ++ "totalTime,"
                    ++ "preparationTime,"
                    ++ "instructions,"
                    ++ "image,"
                    ++ "tags,"
                    ++ "&fields[tags]=tid,name"
                )
    in
        RemoteData.sendRequest request
            |> Cmd.map RecipeLoaded


fileDecoder : Decoder File
fileDecoder =
    map File
        (field "url" string)


termDecoder : Decoder Term
termDecoder =
    map2 Term
        (field "tid" int)
        (field "name" string)


mediaDecoder : Decoder Media
mediaDecoder =
    map Media
        (field "uuid" string)


decodeRecipe : Flags -> JsonApi.Resource -> Result String Recipe
decodeRecipe flags resource =
    let
        id =
            JsonApi.Resources.id resource

        file_image =
            JsonApi.Resources.relatedResource "image" resource
                |> Result.andThen (JsonApi.Resources.relatedResource "imageFile")
                |> Result.andThen (JsonApi.Resources.attributes fileDecoder)

        tags =
            JsonApi.Resources.relatedResourceCollection "tags" resource
                |> Result.andThen
                    (\resources ->
                        (List.map (JsonApi.Resources.attributes termDecoder) resources
                            |> Result.Extra.combine
                        )
                    )
                |> Result.withDefault []
    in
        JsonApi.Resources.attributes (recipeDecoderWithValues id (Result.map .url file_image) tags) resource


resultToWebData : Result String a -> RemoteData.WebData a
resultToWebData result =
    case result of
        Ok value ->
            RemoteData.Success value

        Err string ->
            RemoteData.Failure <|
                Http.BadPayload
                    string
                    { url = ""
                    , status = { code = 200, message = "Ok" }
                    , headers = Dict.empty
                    , body = ""
                    }


decodeArticle : Flags -> JsonApi.Resource -> Result String Article
decodeArticle flags resource =
    let
        id =
            JsonApi.Resources.id resource

        file_image =
            JsonApi.Resources.relatedResource "image" resource
                |> Result.andThen (JsonApi.Resources.relatedResource "image")
                |> Result.andThen (JsonApi.Resources.attributes fileDecoder)
    in
        JsonApi.Resources.attributes (articleDecoderWithIdAndImage id (Result.map .url file_image)) resource


sendContactForm : ContactForm -> Cmd Msg
sendContactForm form =
    let
        body =
            JsonApi.Resources.build "contact_message--contact"
                |> JsonApi.Resources.withAttributes
                    [ ( "name", Json.Encode.string form.name )
                    , ( "email", Json.Encode.string form.email )
                    , ( "subject", Json.Encode.string form.subject )
                    , ( "telephone", Json.Encode.string form.telephone )
                    , ( "message", Json.Encode.string form.message )
                    ]
    in
        Http.post "http://example.com/hat-categories.json" (Http.jsonBody body) (list string)
