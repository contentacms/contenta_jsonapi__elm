module Main exposing (..)

import JsonApi.Http
import Json.Decode exposing (..)
import Task
import JsonApi
import JsonApi.Decode
import JsonApi.Documents
import JsonApi.Resources
import Http
import Html exposing (..)
import Debug
import Result.Extra


type alias Recipe =
    { title : String
    , field_total_time : Int
    }


type alias Model =
    { recipe : Maybe (List Recipe) }


type Msg
    = RecipeLoaded (Result Http.Error (List JsonApi.Resource))
    | GetInitialModel


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetInitialModel ->
            ( model, getRecipe )

        RecipeLoaded (Ok resource) ->
            { model
                | recipe =
                    List.map (JsonApi.Resources.attributes recipeDecoder) resource
                        |> Result.Extra.combine
                        |> Result.toMaybe
            }
                ! []

        RecipeLoaded (Err _) ->
            let
                a =
                    Debug.log "err" Err
            in
                ( model, Cmd.none )


initialModel =
    { recipe =
        Nothing
    }


main =
    Html.program
        { init = update GetInitialModel initialModel
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


view : Model -> Html Msg
view model =
    case model.recipe of
        Nothing ->
            text "No content loaded yet"

        Just recipes ->
            ul []
                (List.map
                    (\recipe ->
                        (li []
                            [ h3 [] [ text "Title" ]
                            , p [] [ text (toString recipe.title) ]
                            , h3 [] [ text "Total time" ]
                            , p [] [ text (toString recipe.field_total_time) ]
                            ]
                        )
                    )
                    recipes
                )
