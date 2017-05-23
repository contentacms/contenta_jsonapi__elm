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
        GetRecipes ->
            ( model, getRecipes )

        GetRecipe string ->
            ( model, getRecipe string )

        RecipeLoaded (Ok resource) ->
            { model
                | recipes =
                    let
                        id =
                            JsonApi.Resources.id resource

                        file_image =
                            JsonApi.Resources.relatedResource "field_image" resource
                                |> Result.andThen (JsonApi.Resources.attributes fileDecoder)
                                |> Result.map (\file -> { file | url = "http://localhost:8890" ++ file.url })
                                |> Result.toMaybe

                        recipeResult =
                            JsonApi.Resources.attributes (recipeDecoderWithIdAndImage id (Maybe.map .url file_image)) resource
                                |> Result.toMaybe
                    in
                        recipeResult
                            |> Maybe.map List.singleton
            }
                ! []

        RecipeLoaded (Err _) ->
            ( model, Cmd.none )

        RecipesLoaded (Ok resources) ->
            { model
                | recipes =
                    List.map
                        (\resource ->
                            let
                                id =
                                    JsonApi.Resources.id resource

                                file_image =
                                    JsonApi.Resources.relatedResource "field_image" resource
                                        |> Result.andThen (JsonApi.Resources.attributes fileDecoder)
                                        |> Result.map (\file -> { file | url = "http://localhost:8890" ++ file.url })
                                        |> Result.toMaybe

                                recipeResult =
                                    JsonApi.Resources.attributes (recipeDecoderWithIdAndImage id (Maybe.map .url file_image)) resource
                                        |> Result.toMaybe
                            in
                                recipeResult
                        )
                        resources
                        |> filterListMaybe
            }
                ! []

        RecipesLoaded (Err _) ->
            ( model, Cmd.none )

        SetActivePage page ->
            case page of
                RecipeDetailPage string ->
                    { model | currentPage = page }
                        |> update (GetRecipe string)

                RecipeList ->
                    { model | currentPage = page }
                        |> update GetRecipes

                _ ->
                    ( { model | currentPage = page }, Cmd.none )

        SelectRecipe string ->
            { model | selectedRecipe = Just string } ! []

        LoginFormState bool ->
            { model | loginFormActive = bool } ! []

        InputLoginName string ->
            ( model, Cmd.none )

        InputLoginPassword string ->
            ( model, Cmd.none )

        InputLoginSubmit ->
            ( model
                |> Debug.log "login submit"
            , Cmd.none
            )



--        LoginCompleted ->
--            ( model, Cmd.none )


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
