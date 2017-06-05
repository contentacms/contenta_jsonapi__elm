module App.Pages.RecipeDetailPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Atom exposing (..)
import App.View.Components exposing (viewRemoteData)
import App.View.Template exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ viewRemoteData
            recipeDetail
            model.pages.recipe
        , sectionTitle "More recipes"
        , text "TODO load more recipes!!"
        ]
