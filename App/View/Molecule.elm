module App.View.Molecule exposing (recipeCard)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import App.View.Atom exposing (..)


recipeCard : Recipe -> Html Msg
recipeCard recipe =
    div []
        [ image <| Maybe.withDefault "http://placekitten.com/g/200/300" recipe.image
        , cardTags <| List.map (.name) recipe.tags
        , cardTitle recipe.title
        ]
