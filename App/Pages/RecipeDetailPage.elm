module App.Pages.RecipeDetailPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Components exposing (viewRecipe)


view : Model -> Html Msg
view model =
    viewRemoteData
        model.recipes
        (\recipes ->
            List.head recipes
                |> Maybe.map viewRecipe
                |> Maybe.withDefault (text "Recipe not found")
        )


viewRemoteData : WebData a -> (a -> Html msg) -> Html msg
viewRemoteData webdata innerView =
    case webdata of
        NotAsked ->
            text "Initialisting"

        Loading ->
            text "Loading"

        Failure err ->
            text ("Error: " ++ toString err)

        Success a ->
            innerView a
