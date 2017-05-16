module App.Update exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import JsonApi.Resources
import Result.Extra


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetInitialModel ->
            ( model, getRecipe )

        RecipesLoaded (Ok resource) ->
            { model
                | recipe =
                    List.map (JsonApi.Resources.attributes recipeDecoder) resource
                        |> Result.Extra.combine
                        |> Result.toMaybe
            }
                ! []

        RecipesLoaded (Err _) ->
            ( model, Cmd.none )

        SetActivePage page ->
            ( { model | currentPage = page }, Cmd.none )
