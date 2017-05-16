module Main exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import App.PageType exposing (..)
import App.View exposing (..)
import App.Update exposing (..)
import Html


initialModel =
    { recipe =
        Nothing
    , currentPage = Home
    }


main =
    Html.program
        { init = (initialModel, Cmd.none)
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
