module App.Pages.RecipeDetailPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Components exposing (viewRecipe)
import App.View.Components exposing (viewRemoteData)


view : Model -> Html Msg
view model =
    viewRemoteData
        (\recipes ->
            List.head recipes
                |> Maybe.map viewRecipe
                |> Maybe.withDefault (text "Recipe not found")
        )
        model.recipes
