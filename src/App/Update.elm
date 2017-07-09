module App.Update exposing (..)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.ModelHttp exposing (..)
import JsonApi.Resources
import Result.Extra
import List exposing (filter)
import Http exposing (Error(..), Response)
import Maybe
import RemoteData exposing (RemoteData(..), fromResult)
import DictList
import Material
import Material.Layout


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetArticles ->
            ( { model | pageArticles = RemoteData.Loading }, getArticles model.flags )

        RecipeLoaded remoteResponse ->
            ( { model
                | pageRecipeDetail =
                    { recipe = RemoteData.andThen (\res -> resultToWebData <| decodeRecipe model.flags res) remoteResponse
                    , recipes = model.pageRecipeDetail.recipes
                    }
              }
            , Cmd.none
            )

        RecipeRecipesLoaded remoteResponse ->
            ( { model
                | pageRecipeDetail =
                    { recipes =
                        RemoteData.map
                            (\resources ->
                                List.map
                                    (decodeRecipe model.flags)
                                    resources
                                    |> removeErrorFromList
                            )
                            remoteResponse
                    , recipe = model.pageRecipeDetail.recipe
                    }
              }
            , Cmd.none
            )

        ArticlesLoaded remoteResponse ->
            ( { model
                | pageArticles =
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

        ClickDrawerLink page ->
            let
                ( model0, cmd0 ) =
                    update (Material.Layout.toggleDrawer Mdl) model

                ( model1, cmd1 ) =
                    update (SetActivePage page) model0
            in
                ( model1, Cmd.batch [ cmd0, cmd1 ] )

        SetActivePage page ->
            case page of
                Home ->
                    ( { model
                        | currentPage = Home
                        , pageHome =
                            { promotedArticles = RemoteData.Loading
                            , promotedRecipes = RemoteData.Loading
                            , recipes = RemoteData.Loading
                            }
                      }
                    , Cmd.batch [ getPromotedRecipes model.flags, getPromotedArticles model.flags, getHomepageRecipes model.flags ]
                    )

                RecipeDetailPage recipeId ->
                    ( { model
                        | currentPage = RecipeDetailPage recipeId
                        , pageRecipeDetail =
                            { recipe = RemoteData.Loading
                            , recipes = RemoteData.Loading
                            }
                      }
                    , Cmd.batch [ getRecipe model.flags recipeId, getRecipeRecipes model.flags ]
                    )

                RecipesPerCategoryList ->
                    ({ model | currentPage = RecipesPerCategoryList, pageRecipes = DictList.empty })
                        |> update GetRecipesPerCategories

                ArticleList ->
                    { model | currentPage = ArticleList, pageArticles = RemoteData.Loading }
                        |> update GetArticles

                AboutUs ->
                    ( { model | currentPage = AboutUs, pageAboutUs = {} }, Cmd.none )

                ContactPage ->
                    ( { model
                        | currentPage = ContactPage
                        , pageContact =
                            { name = ""
                            , email = ""
                            , telephone = ""
                            , subject = ""
                            , message = ""
                            }
                      }
                    , Cmd.none
                    )

                RecipesPerTagPage tag ->
                    ( { model
                        | currentPage = RecipesPerTagPage tag
                        , pageRecipesPerTag = ( tag, RemoteData.Loading )
                      }
                    , getRecipesPerTag model.flags tag
                    )

                RecipesPerCategoryPage category ->
                    ( { model
                        | currentPage = RecipesPerCategoryPage category
                        , pageRecipesPerCategory = ( category, RemoteData.Loading )
                      }
                    , getRecipesPerCategory model.flags category
                    )

        PromotedArticlesLoaded remoteResponse ->
            ( { model
                | pageHome =
                    { promotedArticles =
                        RemoteData.map
                            (\resources ->
                                List.map
                                    (decodeArticle model.flags)
                                    resources
                                    |> removeErrorFromList
                            )
                            remoteResponse
                    , promotedRecipes = model.pageHome.promotedRecipes
                    , recipes = model.pageHome.recipes
                    }
              }
            , Cmd.none
            )

        PromotedRecipesLoaded remoteResponse ->
            ( { model
                | pageHome =
                    { promotedRecipes =
                        RemoteData.map
                            (\resources ->
                                List.map
                                    (decodeRecipe model.flags)
                                    resources
                                    |> removeErrorFromList
                            )
                            remoteResponse
                    , promotedArticles = model.pageHome.promotedArticles
                    , recipes = model.pageHome.recipes
                    }
              }
            , Cmd.none
            )

        HomepageRecipesLoaded remoteResponse ->
            ( { model
                | pageHome =
                    { promotedRecipes = model.pageHome.promotedRecipes
                    , promotedArticles = model.pageHome.promotedArticles
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

        GetRecipesPerCategories ->
            ( { model
                | pageRecipes =
                    DictList.fromList
                        [ ( "Main course", RemoteData.Loading )
                        , ( "Starter", RemoteData.Loading )
                        , ( "Snack", RemoteData.Loading )
                        , ( "Salad", RemoteData.Loading )
                        , ( "Dessert", RemoteData.Loading )
                        ]
              }
            , Cmd.batch
                [ getRecipesPerCategory model.flags "Main course"
                , getRecipesPerCategory model.flags "Starter"
                , getRecipesPerCategory model.flags "Snack"
                , getRecipesPerCategory model.flags "Salad"
                , getRecipesPerCategory model.flags "Dessert"
                ]
            )

        RecipesPerCategoryLoaded category remoteResponse ->
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
                case model.currentPage of
                    RecipesPerCategoryList ->
                        ( { model
                            | pageRecipes =
                                DictList.insert category additionalRecipes model.pageRecipes
                          }
                        , Cmd.none
                        )

                    RecipesPerCategoryPage _ ->
                        ( { model | pageRecipesPerTag = ( category, additionalRecipes ) }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

        RecipesPerTagLoaded tag remoteResponse ->
            let
                recipes =
                    RemoteData.map
                        (\resources ->
                            List.map
                                (decodeRecipe model.flags)
                                resources
                                |> removeErrorFromList
                        )
                        remoteResponse
            in
                ( { model | pageRecipesPerTag = ( tag, recipes ) }, Cmd.none )

        PostContactForm ->
            ( model, sendContactForm model.pageContact )

        ContactM msg ->
            ( { model | pageContact = updateContact msg model.pageContact }, Cmd.none )

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
