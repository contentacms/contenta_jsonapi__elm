module App.Pages.RecipesPerCategoryList exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Components exposing (viewRecipe, viewRemoteData)
import Dict
import App.View.Organism exposing (..)


view : Model -> Html Msg
view model =
    let
        foo =
            Dict.toList model.pages.recipes
                |> Debug.log "RecipesPerCategoryList"
    in
        div []
            (Dict.toList model.pages.recipes
                |> List.map
                    (\( category, recipes ) ->
                        viewRemoteData (recipesPerCategory category) recipes
                    )
            )



--        (Dict.toList model.pages.recipes
--            |> List.map (viewRemoteData (uncurry recipesPerCategory))
--        )
