module App.Pages.RecipeList exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import App.View.Components exposing (viewRecipe)


view : Model -> Html Msg
view =
    viewRecipes


viewRecipes : Model -> Html Msg
viewRecipes model =
    case model.recipes of
        Nothing ->
            text "No content loaded yet"

        Just recipes ->
            ul []
                (List.map
                    (\recipe ->
                        (li [] [ viewRecipe recipe ])
                    )
                    recipes
                )
