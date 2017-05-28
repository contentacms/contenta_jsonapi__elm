module App.Pages.RecipeSelectionPage exposing (view)

import App.Model exposing (..)
import App.PageType exposing (Page(..))
import App.View.Components exposing (viewRemoteData)
import Html exposing (..)
import Html.Attributes exposing (src, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import RemoteData exposing (WebData, RemoteData(..))


view : Model -> Html Msg
view model =
    Html.form []
        [ label [] [ text "Select recipe" ]
        , viewRemoteData model.recipes
            (\recipes ->
                case recipes of
                    [] ->
                        text "No recipe available"

                    actualRecipes ->
                        select [ onInput (\id -> SetActivePage <| RecipeDetailPage id) ] <|
                            List.append
                                [ option [] [ text "Nothing" ] ]
                            <|
                                (List.map
                                    (\recipe ->
                                        option [ value recipe.id ] [ text recipe.title ]
                                    )
                                    actualRecipes
                                )
            )
        ]
