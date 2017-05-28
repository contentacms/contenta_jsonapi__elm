module App.Update exposing (..)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.ModelHttp exposing (..)
import JsonApi.Resources
import Result.Extra
import List exposing (filter)
import Http exposing (Error(..), Response)
import Maybe
import RemoteData exposing (RemoteData(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRecipes ->
            ( model, getRecipes model.flags )

        GetArticles ->
            ( model, getArticles model.flags )

        GetRecipe string ->
            ( model, getRecipe model.flags string )

        RecipeLoaded (Ok resource) ->
            { model
                | recipes =
                    (decodeRecipe model.flags) resource
                        |> Maybe.map List.singleton
            }
                ! []

        RecipeLoaded (Err err) ->
            updateError "error: RecipeLoaded" err model

        RecipesLoaded (Ok resources) ->
            { model
                | recipes =
                    List.map
                        (decodeRecipe model.flags)
                        resources
                        |> joinListMaybe
            }
                ! []

        RecipesLoaded (Err err) ->
            updateError "error: RecipesLoaded" err model

        ArticlesLoaded (Ok resources) ->
            let
                pages =
                    model.pages

                articlesPage =
                    pages.articles

                newArticlesPage =
                    { articlesPage
                        | articles =
                            List.map
                                (decodeArticle model.flags)
                                resources
                                |> joinListMaybe
                    }

                newPages =
                    { pages | articles = newArticlesPage }
            in
                { model | pages = newPages } ! []

        ArticlesLoaded (Err err) ->
            updateError "error: ArticlesLoaded" err model

        SetActivePage page ->
            case page of
                Home ->
                    let
                        pagesModel =
                            model.pages

                        newPagesModel =
                            { pagesModel
                                | home =
                                    { promotedArticles = RemoteData.Loading
                                    , promotedRecipes = RemoteData.Loading
                                    }
                            }
                    in
                        ( { model | currentPage = page, pages = newPagesModel }
                        , Cmd.batch [ getPromotedRecipes model.flags, getPromotedArticles model.flags, getRecipes model.flags ]
                        )

                RecipeDetailPage string ->
                    { model | currentPage = page }
                        |> update (GetRecipe string)

                RecipeList ->
                    { model | currentPage = page }
                        |> update GetRecipes

                ArticleList ->
                    { model | currentPage = page }
                        |> update GetArticles

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
        PromotedArticlesLoaded remoteResponse ->
            -- @todo: Nested data models aren't ideal.
            let
                pages =
                    model.pages

                homePageModel =
                    pages.home

                newHomePageModel =
                    { homePageModel
                        | promotedArticles =
                            RemoteData.map
                                (\resources ->
                                    List.map
                                        (decodeArticle model.flags)
                                        resources
                                        |> removeMaybeFromList
                                )
                                remoteResponse
                    }

                newPages =
                    { pages | home = newHomePageModel }
            in
                { model | pages = newPages } ! []

        PromotedRecipesLoaded remoteResponse ->
            -- @todo: Nested data models aren't ideal.
            let
                pages =
                    model.pages

                homePageModel =
                    pages.home

                newHomePageModel =
                    { homePageModel
                        | promotedRecipes =
                            RemoteData.map
                                (\resources ->
                                    List.map
                                        (decodeRecipe model.flags)
                                        resources
                                        |> removeMaybeFromList
                                )
                                remoteResponse
                    }

                newPages =
                    { pages | home = newHomePageModel }
            in
                { model | pages = newPages } ! []


joinListMaybe : List (Maybe a) -> Maybe (List a)
joinListMaybe list =
    let
        filteredList =
            List.filterMap identity list
    in
        case (List.length filteredList) of
            0 ->
                Nothing

            _ ->
                Just filteredList


removeMaybeFromList : List (Maybe a) -> List a
removeMaybeFromList list =
    case (List.reverse list) of
        (Just a) :: xs ->
            a :: removeMaybeFromList xs

        Nothing :: xs ->
            removeMaybeFromList xs

        [] ->
            []


updateError : String -> Http.Error -> Model -> ( Model, Cmd Msg )
updateError debugMessage error model =
    let
        _ =
            Debug.log debugMessage <| errorString error
    in
        ( model, Cmd.none )


errorString : Http.Error -> String
errorString error =
    case error of
        BadUrl string ->
            "BadUrl " ++ string

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus response ->
            "BadStatus " ++ toString (response.status)

        BadPayload string response ->
            "BadPayload " ++ string
