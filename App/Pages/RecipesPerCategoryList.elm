module App.Pages.RecipesPerCategoryList exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Components exposing (viewRemoteData)
import Dict
import App.View.Components exposing (viewRecipe)


view : Model -> Html Msg
view model =
    div []
        (Dict.toList model.pages.recipes
            |> List.map
                (uncurry
                    (\category recipes ->
                        div []
                            [ h3 []
                                [ text category ]
                            , viewRemoteData
                                viewRecipes
                                recipes
                            ]
                    )
                )
        )


viewRecipes : List Recipe -> Html Msg
viewRecipes recipes =
    ul []
        (List.map
            (\recipe ->
                (li [] [ viewRecipe recipe ])
            )
            recipes
        )
