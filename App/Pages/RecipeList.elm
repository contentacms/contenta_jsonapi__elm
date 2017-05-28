module App.Pages.RecipeList exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import App.View.Components exposing (viewRecipe)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Components exposing (viewRemoteData)


view : Model -> Html Msg
view =
    viewRecipes


viewRecipes : Model -> Html Msg
viewRecipes model =
    viewRemoteData model.recipes
        (\recipes ->
            ul []
                (List.map
                    (\recipe ->
                        (li [] [ viewRecipe recipe ])
                    )
                    recipes
                )
        )
