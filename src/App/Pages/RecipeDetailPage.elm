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


view : Model -> Html Msg
view model =
    div []
        [ viewRemoteData
            recipeDetail
            model.pages.recipe.recipe
        , viewRemoteData
            (\recipes ->
                div []
                    [ sectionTitle "More recipes"
                    , grid4 <| List.map recipeCard recipes
                    ]
            )
            model.pages.recipe.recipes
        ]
