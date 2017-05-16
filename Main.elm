module Main exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import App.View exposing (..)
import App.Update exposing (..)

import Html

initialModel =
    { recipe =
        Nothing
    }

main =
    Html.program
        { init = update GetInitialModel initialModel
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


