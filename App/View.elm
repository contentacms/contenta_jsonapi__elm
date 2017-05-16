module App.View exposing (view)

import App.Model exposing (..)
import App.PageType exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import List


view : Model -> Html Msg
view model =
    div []
        [ (viewHeader model)
        , (case model.currentPage of
            Home ->
                viewHome model

            RecipeList ->
                viewRecipes model

            RecipePage string ->
                text string
          )
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    ul []
        [ li [] [ a [ href "#", onClick (SetActivePage Home) ] [ text "Home" ] ]
        , li [] [ a [ href "#", onClick (SetActivePage RecipeList) ] [ text "Recipes" ] ]
        , li [] [ a [ href "#", onClick (SetActivePage (RecipePage "123")) ] [ text "Recipe 123" ] ]
        ]


viewHome : Model -> Html Msg
viewHome model =
    text "Home page"


viewRecipes : Model -> Html Msg
viewRecipes model =
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
