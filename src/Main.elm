module Main exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import App.Router exposing (..)
import App.View exposing (..)
import App.Update exposing (..)
import Html
import RouteUrl
import RemoteData exposing (RemoteData)
import Dict
import Material


init : Flags -> Model
init flags =
    { flags = flags
    , currentPage = Home
    , pages =
        HomeModel
            { promotedArticles = RemoteData.NotAsked
            , promotedRecipes = RemoteData.NotAsked
            , recipes = RemoteData.NotAsked
            }
    , mdl = Material.model
    }


main =
    RouteUrl.programWithFlags
        { delta2url = delta2url
        , location2messages = location2messages
        , init =
            \flags ->
                init flags
                    |> update (SetActivePage Home)
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
