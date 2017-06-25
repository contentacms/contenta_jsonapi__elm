module App.Pages.RecipeDetailPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Atom exposing (..)
import App.View.Molecule exposing (recipeCard)
import App.View.Components exposing (viewRemoteData)
import App.View.Template exposing (..)
import App.View.Grid exposing (grid4)


view : Model -> PageRecipeDetailModel -> Html Msg
view model pageModel =
    div []
        [ viewRemoteData
            recipeDetail
            pageModel.recipe
        , viewRemoteData
            (\recipes ->
                div []
                    [ sectionTitle "More recipes"
                    , grid4 <| List.map recipeCard recipes
                    ]
            )
            pageModel.recipes
        ]
