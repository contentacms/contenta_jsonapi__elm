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
            ( { model | pages = ArticleListModel RemoteData.Loading }, getArticles model.flags )

        RecipeLoaded remoteResponse ->
            case model.pages of
                RecipeDetailPageModel { recipe, recipes } ->
                    ( { model
                        | pages =
                            RecipeDetailPageModel
                                { recipe = RemoteData.andThen (\res -> resultToWebData <| decodeRecipe model.flags res) remoteResponse
                                , recipes = recipes
                                }
                      }
                    , Cmd.none
                    )

                _ ->
                    Debug.crash "This should never happen"

        RecipeRecipesLoaded remoteResponse ->
            case model.pages of
                RecipeDetailPageModel { recipe, recipes } ->
                    ( { model
                        | pages =
                            RecipeDetailPageModel
                                { recipe = recipe
                                , recipes =
                                    RemoteData.map
                                        (\resources ->
                                            List.map
                                                (decodeRecipe model.flags)
                                                resources
                                                |> removeErrorFromList
                                        )
                                        remoteResponse
                                }
                      }
                    , Cmd.none
                    )

                _ ->
                    Debug.crash "This should never happen"

        ArticlesLoaded remoteResponse ->
            case model.pages of
                ArticleListModel articles ->
                    ( { model
                        | pages =
                            ArticleListModel <|
                                RemoteData.map
                                    (\resources ->
                                        List.map
                                            (decodeArticle model.flags)
                                            resources
                                            |> removeErrorFromList
                                    )
                                    remoteResponse
                      }
                    , Cmd.none
                    )

                _ ->
                    Debug.crash "This should never happen"

        SetActivePage page ->
            case page of
                Home ->
                    ( { model
                        | currentPage = page
                        , pages =
                            HomeModel
                                { promotedArticles = RemoteData.Loading
                                , promotedRecipes = RemoteData.Loading
                                , recipes = RemoteData.Loading
                                }
                      }
                    , Cmd.batch [ getPromotedRecipes model.flags, getPromotedArticles model.flags, getHomepageRecipes model.flags ]
                    )

                RecipeDetailPage string ->
                    ( { model
                        | currentPage = page
                        , pages =
                            RecipeDetailPageModel
                                { recipe = RemoteData.Loading
                                , recipes = RemoteData.Loading
                                }
                      }
                    , Cmd.batch [ getRecipe model.flags string, getRecipeRecipes model.flags ]
                    )

                RecipesPerCategoryList ->
                    { model | currentPage = page }
                        |> update GetRecipesPerCategories

                ArticleList ->
                    ({ model | currentPage = page, pages = ArticleListModel RemoteData.Loading })
                        |> update GetArticles

                AboutUs ->
                    ( { model | currentPage = page, pages = AboutUsModel }, Cmd.none )

                ContactPage ->
                    ( { model
                        | currentPage = page
                        , pages =
                            ContactPageModel
                                { name = ""
                                , email = ""
                                , telephone = ""
                                , subject = ""
                                , message = ""
                                }
                      }
                    , Cmd.none
                    )

        PromotedArticlesLoaded remoteResponse ->
            case model.pages of
                HomeModel { promotedArticles, promotedRecipes, recipes } ->
                    ( { model
                        | pages =
                            HomeModel
                                { promotedArticles =
                                    RemoteData.map
                                        (\resources ->
                                            List.map
                                                (decodeArticle model.flags)
                                                resources
                                                |> removeErrorFromList
                                        )
                                        remoteResponse
                                , promotedRecipes = promotedRecipes
                                , recipes = recipes
                                }
                      }
                    , Cmd.none
                    )

                _ ->
                    Debug.crash "This should not happen"

        PromotedRecipesLoaded remoteResponse ->
            case model.pages of
                HomeModel { promotedArticles, promotedRecipes, recipes } ->
                    ( { model
                        | pages =
                            HomeModel
                                { promotedArticles = promotedArticles
                                , promotedRecipes =
                                    RemoteData.map
                                        (\resources ->
                                            List.map
                                                (decodeRecipe model.flags)
                                                resources
                                                |> removeErrorFromList
                                        )
                                        remoteResponse
                                , recipes = recipes
                                }
                      }
                    , Cmd.none
                    )

                _ ->
                    Debug.crash "This should not happen"

        HomepageRecipesLoaded remoteResponse ->
            case model.pages of
                HomeModel { promotedArticles, promotedRecipes, recipes } ->
                    ( { model
                        | pages =
                            HomeModel
                                { promotedArticles = promotedArticles
                                , promotedRecipes = promotedRecipes
                                , recipes =
                                    RemoteData.map
                                        (\resources ->
                                            List.map
                                                (decodeRecipe model.flags)
                                                resources
                                                |> removeErrorFromList
                                        )
                                        remoteResponse
                                }
                      }
                    , Cmd.none
                    )

                _ ->
                    Debug.crash "This should not happen"

        GetRecipesPerCategories ->
            ( { model
                | pages =
                    RecipesPerCategoryListModel <|
                        Dict.fromList
                            [ ( "Main course", RemoteData.Loading )
                            , ( "Snack", RemoteData.Loading )
                            , ( "Dessert", RemoteData.Loading )
                            ]
              }
            , Cmd.batch
                [ getRecipePerCategory model.flags "Main course"
                , getRecipePerCategory model.flags "Snack"
                , getRecipePerCategory model.flags "Dessert"
                ]
            )

        RecipesPerCategoryLoaded category remoteResponse ->
            case model.pages of
                RecipesPerCategoryListModel recipes ->
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
                    in
                        ( { model
                            | pages =
                                RecipesPerCategoryListModel <|
                                    Dict.insert category additionalRecipes recipes
                          }
                        , Cmd.none
                        )

                _ ->
                    Debug.crash "this should not happen"

        PostContactForm ->
            case model.pages of
                ContactPageModel contact ->
                    ( model, sendContactForm contact )

                _ ->
                    Debug.crash "this should not happen"

        ContactM msg ->
            case model.pages of
                ContactPageModel contact ->
                    ( { model | pages = ContactPageModel <| updateContact msg contact }, Cmd.none )

                _ ->
                    Debug.crash "this should not happen"

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
