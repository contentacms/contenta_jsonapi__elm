module App.Pages.RecipePerTagPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData, RemoteData, RemoteData(..))
import App.View.Components exposing (viewRemoteData)
import App.View.Organism exposing (..)


view : Model -> PageRecipesPerTagModel -> Html Msg
view model pageModel =
    viewRemoteData (uncurry recipesPerCategory) pageModel
