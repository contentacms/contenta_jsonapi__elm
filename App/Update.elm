module App.Update exposing (..)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.ModelHttp exposing (..)
import JsonApi.Resources
import Result.Extra
import List exposing (filter)
import Maybe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetInitialModel ->
            ( model, getRecipe )

        RecipesLoaded (Ok resources) ->
            { model
                | recipe =
                    List.map
                        (\resource ->
                            let
                                file_image =
                                    JsonApi.Resources.relatedResource "field_image" resource
                                        |> Result.andThen (JsonApi.Resources.attributes fileDecoder)
                                        |> Result.map (\file -> { file | url = "http://localhost:8890" ++ file.url })
                                        |> Result.toMaybe

                                resourceResult =
                                    JsonApi.Resources.attributes (recipeDecoderWithImage (Maybe.map .url file_image)) resource
                                        |> Debug.log "muh"
                                        |> Result.toMaybe
                            in
                                resourceResult
                        )
                        resources
                        |> filterListMaybe
            }
                ! []

        RecipesLoaded (Err _) ->
            ( model, Cmd.none )

        SetActivePage page ->
            case page of
                RecipeList ->
                    { model | currentPage = page }
                        |> update GetInitialModel

                _ ->
                    ( { model | currentPage = page }, Cmd.none )


filterListMaybe : List (Maybe a) -> Maybe (List a)
filterListMaybe list =
    let
        filteredList =
            List.filterMap identity list
    in
        case (List.length filteredList) of
            0 ->
                Nothing

            _ ->
                Just filteredList
