module App.Pages.RecipesPerCategoryList exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import App.View.Components exposing (viewRemoteData)
import Dict exposing (Dict)
import App.View.Organism exposing (..)


view : Model -> Dict String (WebData (List Recipe)) -> Html Msg
view model recipesDict =
    div []
        [ recipesFeaturedHeader
        , div
            []
            (Dict.toList recipesDict
                |> List.map
                    (\( category, recipes ) ->
                        viewRemoteData (recipesPerCategory category) recipes
                    )
            )
        , recipeMoreArticlesTeaser
        ]
