module App.View exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import List


view : Model -> Html Msg
view model =
    case model.recipe of
        Nothing ->
            text "No content loaded yet"

        Just recipes ->
            ul []
                (List.map
                    (\recipe ->
                        (li [] [ viewRecipe recipe ])
                    )
                    recipes
                )


viewRecipe : Recipe -> Html Msg
viewRecipe recipe =
    div []
        [ h3 [] [ text "Title" ]
        , p [] [ text (toString recipe.title) ]
        , h3 [] [ text "Total time" ]
        , p [] [ text (toString recipe.field_total_time) ]
        ]
