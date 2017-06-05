module App.Pages.RecipesPerCategoryList exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import RemoteData exposing (RemoteData(..))
import App.View.Components exposing (viewRemoteData)
import Dict
import App.View.Organism exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ recipesFeaturedHeader
        , div
            []
            (Dict.toList model.pages.recipes
                |> List.map
                    (\( category, recipes ) ->
                        viewRemoteData (recipesPerCategory category) recipes
                    )
            )
        , recipeMoreArticlesTeaser
        ]
