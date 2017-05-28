module App.Pages.RecipeSelectionPage exposing (view)

import App.Model exposing (..)
import App.PageType exposing (Page(..))
import Html exposing (..)
import Html.Attributes exposing (src, value)
import Html.Events exposing (onClick, onInput, onSubmit)


view : Model -> Html Msg
view model =
    Html.form []
        [ label [] [ text "Select recipe" ]
        , Maybe.withDefault
            (text "No recipe available")
            (Maybe.andThen
                (\recipes ->
                    (Just
                        (select [ onInput (\id -> SetActivePage <| RecipeDetailPage id) ] <|
                            List.append
                                [ option [] [ text "Nothing" ] ]
                            <|
                                (List.map
                                    (\recipe ->
                                        option [ value recipe.id ] [ text recipe.title ]
                                    )
                                    recipes
                                )
                        )
                    )
                )
                model.recipes
            )
        ]
