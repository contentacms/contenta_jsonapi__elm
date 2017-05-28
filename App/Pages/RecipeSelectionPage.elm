module App.Pages.RecipeSelectionPage exposing (view)

import App.Model exposing (..)
import App.PageType exposing (Page(..))
import Html exposing (..)
import Html.Attributes exposing (src, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import RemoteData exposing (WebData, RemoteData(..))


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
