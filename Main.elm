module Main exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import App.PageType exposing (..)
import App.Router exposing (..)
import App.View exposing (..)
import App.Update exposing (..)
import Html
import RouteUrl
import RemoteData exposing (RemoteData)


initialModel : Model
initialModel =
    { recipes =
        RemoteData.NotAsked
    , flags =
        { baseUrl = "http://localhost:8888"
        , apiBaseUrl = "http://localhost:8888/jsonapi"
        }
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
            { promotedArticles = RemoteData.NotAsked
            , promotedRecipes = RemoteData.NotAsked
            }
        , articles =
            { articles = RemoteData.NotAsked
            }
        }
    }


main =
    RouteUrl.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init = update (SetActivePage Home) initialModel
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
