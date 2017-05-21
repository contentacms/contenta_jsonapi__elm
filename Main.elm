module Main exposing (..)

import App.Model exposing (..)
import App.ModelHttp exposing (..)
import App.PageType exposing (..)
import App.View exposing (..)
import App.Update exposing (..)
import Html


initialModel =
    { recipes =
        Nothing
    , currentPage = Home
    , selectedRecipe = Nothing
    }


main =
    Html.program
        { init = update (SetActivePage RecipeList) initialModel
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
