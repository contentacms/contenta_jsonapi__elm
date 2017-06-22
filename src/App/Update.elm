module App.Update exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import JsonApi.Resources
import Result.Extra
import List exposing (filter)
import Http exposing (Error(..), Response)
import Maybe
import RemoteData exposing (RemoteData(..), fromResult)
import Dict
import Material


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetArticles ->
            let
                pages =
                    model.pages

                pages_ =
                    { pages
                        | articles = RemoteData.Loading
                    }
            in
                ( { model | pages = pages_ }, getArticles model.flags )

        RecipeLoaded remoteResponse ->
            let
                pages =
                    model.pages

                recipePage =
                    pages.recipe

                recipePage_ =
                    { recipePage
                        | recipe =
                            RemoteData.andThen (\res -> resultToWebData <| decodeRecipe model.flags res) remoteResponse
                    }

                pages_ =
                    { pages | recipe = recipePage_ }
            in
                { model | pages = pages_ }
                    ! []

        RecipeRecipesLoaded remoteResponse ->
            -- @todo: Nested data models aren't ideal.
            let
                pages =
                    model.pages

                recipePage =
                    pages.recipe

                recipePage_ =
                    { recipePage
                        | recipes =
                            RemoteData.map
                                (\resources ->
                                    List.map
                                        (decodeRecipe model.flags)
                                        resources
                                        |> removeErrorFromList
                                )
                                remoteResponse
                    }

                pages_ =
                    { pages | recipe = recipePage_ }
            in
                { model | pages = pages_ } ! []

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
                                        |> removeErrorFromList
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
                                    , recipes = RemoteData.Loading
                                    }
                            }
                    in
                        ( { model | currentPage = page, pages = newPagesModel }
                        , Cmd.batch [ getPromotedRecipes model.flags, getPromotedArticles model.flags, getHomepageRecipes model.flags ]
                        )

                RecipeDetailPage string ->
                    let
                        pages =
                            model.pages

                        recipePage =
                            pages.recipe

                        recipePage_ =
                            { recipe = RemoteData.Loading, recipes = RemoteData.Loading }

                        pages_ =
                            { pages | recipe = recipePage_ }
                    in
                        ( { model | currentPage = page, pages = pages_ }, Cmd.batch [ getRecipe model.flags string, getRecipeRecipes model.flags ] )

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
                                        |> removeErrorFromList
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
                                        |> removeErrorFromList
                                )
                                remoteResponse
                    }

                newPages =
                    { pages | home = newHomePageModel }
            in
                { model | pages = newPages } ! []

        HomepageRecipesLoaded remoteResponse ->
            -- @todo: Nested data models aren't ideal.
            let
                pages =
                    model.pages

                homePageModel =
                    pages.home

                newHomePageModel =
                    { homePageModel
                        | recipes =
                            RemoteData.map
                                (\resources ->
                                    List.map
                                        (decodeRecipe model.flags)
                                        resources
                                        |> removeErrorFromList
                                )
                                remoteResponse
                    }

                newPages =
                    { pages | home = newHomePageModel }
            in
                { model | pages = newPages } ! []

        GetRecipesPerCategories ->
            let
                pages =
                    model.pages

                pages_ =
                    { pages
                        | recipes =
                            Dict.fromList
                                [ ( "Main course", RemoteData.Loading )
                                , ( "Snack", RemoteData.Loading )
                                , ( "Dessert", RemoteData.Loading )
                                ]
                    }
            in
                ( { model | pages = pages_ }
                , Cmd.batch
                    [ getRecipePerCategory model.flags "Main course"
                    , getRecipePerCategory model.flags "Snack"
                    , getRecipePerCategory model.flags "Dessert"
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
                                |> removeErrorFromList
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

        PostContactForm ->
            ( model, sendContactForm model.pages.contact )

        ContactM msg ->
            let
                pages =
                    model.pages

                contact =
                    pages.contact

                pages_ =
                    { pages
                        | contact = updateContact msg contact
                    }
            in
                { model | pages = pages_ } ! []

        {- Implement the contact post result -}
        ContactPostResult ->
            ( model, Cmd.none )

        Mdl message ->
            Material.update Mdl message model


updateContact : ContactMsg -> ContactForm -> ContactForm
updateContact msg form =
    case msg of
        SetName string ->
            { form | name = string }

        SetEmail string ->
            { form | email = string }

        SetSubject string ->
            { form | subject = string }

        SetTelephone string ->
            { form | telephone = string }

        SetMessage string ->
            { form | message = string }

        SubmitForm ->
            form


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


removeErrorFromList : List (Result a b) -> List b
removeErrorFromList list =
    case (List.reverse list) of
        (Ok a) :: xs ->
            a :: removeErrorFromList xs

        (Err b) :: xs ->
            removeErrorFromList xs

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
