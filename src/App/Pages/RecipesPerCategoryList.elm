module App.Pages.RecipesPerCategoryList exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import App.View.Atom exposing (viewRemoteData, viewRemoteDataWithTitle)
import DictList exposing (DictList)
import App.View.Organism exposing (..)


view : Model -> PageRecipesModel -> Html Msg
view model pageModel =
    div []
        [ recipesFeaturedHeader
        , div
            []
            (DictList.toList pageModel
                |> List.map
                    (\( category, recipes ) ->
                        viewRemoteDataWithTitle (recipesPerCategory) recipes category
                    )
            )
        , recipeMoreArticlesTeaser
        ]
