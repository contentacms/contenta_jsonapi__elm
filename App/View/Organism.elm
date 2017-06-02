module App.View.Organism exposing (recipesPerCategory)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import App.View.Atom exposing (..)
import App.View.Molecule exposing (..)


recipesPerCategory : String -> List Recipe -> Html Msg
recipesPerCategory title recipes =
    div []
        [ recipeCategoryTitle title
        , div [] <|
            List.map
                recipeCard
                recipes
        ]


articleCardList : List Article -> Html Msg
articleCardList articles =
    div [] <| List.map articleCard articles
