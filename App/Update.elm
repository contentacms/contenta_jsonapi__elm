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
import Dict


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetArticles ->
            ( model, getArticles model.flags )

        GetRecipe string ->
            ( model, getRecipe model.flags string )

        RecipeLoaded remoteResponse ->
            { model
                | recipes =
                    RemoteData.map (decodeRecipe model.flags) remoteResponse
                        |> RemoteData.map
                            (\recipe ->
                                case recipe of
                                    Nothing ->
                                        []

                                    Just r ->
                                        [ r ]
                            )
            }
                ! []

        ArticlesLoaded remoteResponse ->
            let
                pages =
                    model.pages

                pages_ =
                    { pages
                        | articles =
                            RemoteData.map
                                (\resources ->
                                    List.map
                                        (decodeArticle model.flags)
                                        resources
                                        |> removeMaybeFromList
                                )
                                remoteResponse
                    }
            in
                { model | pages = pages_ } ! []

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
                        , Cmd.batch [ getPromotedRecipes model.flags, getPromotedArticles model.flags ]
                        )

                RecipeDetailPage string ->
                    { model | currentPage = page }
                        |> update (GetRecipe string)

                RecipesPerCategoryList ->
                    { model | currentPage = page }
                        |> update GetRecipesPerCategories

                ArticleList ->
                    let
                        pages =
                            model.pages

                        pages_ =
                            { pages
                                | articles = RemoteData.Loading
                            }
                    in
                        { model | currentPage = page, pages = pages_ }
                            |> update GetArticles

                _ ->
                    { model | currentPage = page } ! []

        SelectRecipe string ->
            { model | selectedRecipe = Just string } ! []

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

        GetRecipesPerCategories ->
            ( model
            , Cmd.batch
                [ getRecipePerCategory model.flags "dessert"
                , getRecipePerCategory model.flags "dinner"
                ]
            )

        RecipesPerCategoryLoaded category remoteResponse ->
            -- @todo: Nested data models aren't ideal.
            let
                additionalRecipes =
                    RemoteData.map
                        (\resources ->
                            List.map
                                (decodeRecipe model.flags)
                                resources
                                |> removeMaybeFromList
                        )
                        remoteResponse

                pages =
                    model.pages

                pages_ =
                    { pages
                        | recipes =
                            Dict.insert category additionalRecipes pages.recipes
                    }
            in
                { model | pages = pages_ } ! []


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
        model ! []


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
