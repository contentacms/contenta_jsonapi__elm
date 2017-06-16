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
import Dict


initialModel : Model
initialModel =
    { flags =
        { baseUrl = "http://localhost:8888"
        , apiBaseUrl = "http://localhost:8888/api"
        }
    , currentPage = Home
    , pages =
        { home =
            { promotedArticles = RemoteData.NotAsked
            , promotedRecipes = RemoteData.NotAsked
            }
        , articles = RemoteData.NotAsked
        , recipes = Dict.empty
        , recipe = RemoteData.NotAsked
        }
    }


main =
    RouteUrl.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init = update (SetActivePage (RecipeDetailPage "1d6a51b3-1a9a-4fa1-89e8-fa45a5fe4318")) initialModel
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
