module Main exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import App.PageType exposing (..)
import App.Router exposing (..)
import App.View exposing (..)
import App.Update exposing (..)
import Html
import RouteUrl


initialModel : Model
initialModel =
    { recipes =
        Nothing
    , selectedRecipe = Nothing
    , loginFormActive = False
    , loginDetails =
        Just
            { name = "Hey"
            , password = "blub"
            }
    , currentPage = Home
    , pages =
        { home =
            { promotedArticles = Nothing
            , promotedRecipes = Nothing
            }
        , articles =
            { articles = Nothing
            }
        }
    }


main =
    RouteUrl.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init = update (SetActivePage ArticleList) initialModel
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
