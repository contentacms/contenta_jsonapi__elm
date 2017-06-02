module App.View.Template exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import App.View.Atom exposing (..)
import App.View.Molecule exposing (..)
import App.View.Organism exposing (..)


recipeDetail : Recipe -> Html Msg
recipeDetail recipe =
    div []
        [ pageTitle recipe.title
        , recipeAuthorLine recipe
        , recipeDetailHeader recipe
        , sectionTitle "What you'll need and how to make this dish"
        , recipeDetailMain recipe
        ]
